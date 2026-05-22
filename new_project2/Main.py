from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import joblib
import os
import sqlite3
from datetime import datetime

app = FastAPI(title="Car Price Production API - 8 Features Integrated")

DB_FILE = "predictions.db"
MODEL_PATH = "car_model.joblib"
CSV_PATH = "2nd_hand_Cars_data.csv"

# --- DATABASE SETUP WITH 8 COLUMNS ---
def init_db():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS car_predictions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT,
            name TEXT,
            year INTEGER,
            kilometers_driven INTEGER,
            fuel_type TEXT,
            transmission TEXT,
            owner_type TEXT,
            engine REAL,
            power REAL,
            predicted_price REAL
        )
    """)
    conn.commit()
    conn.close()

# Run database setup
init_db()

# --- LOAD DATA SOURCE ---
if not os.path.exists(CSV_PATH):
    raise FileNotFoundError(f"Please place your dataset named '{CSV_PATH}' in this folder!")

df = pd.read_csv(CSV_PATH)
df.columns = df.columns.str.strip()  # Clean whitespaces from headers

# Fix the JSON Out-of-Range error by filling empty values with defaults
df = df.fillna("")

# --- UPDATED 8-FEATURE INPUT VALIDATION SCHEMA ---
class CarInput(BaseModel):
    Name: str
    Year: int
    Kilometers_Driven: int
    Fuel_Type: str
    Transmission: str
    Owner_Type: str
    Engine: float
    Power: float

@app.get("/data")
def get_raw_data():
    """Provides raw data for the ML training script"""
    return df.to_dict(orient="records")

@app.get("/meta")
def get_metadata():
    """Provides unique properties to dynamically build Streamlit menus"""
    return {
        "names": sorted(df["Name"].astype(str).unique().tolist()),
        "years": sorted(df["Year"].astype(int).unique().tolist(), reverse=True),
        "fuel_types": df["Fuel_Type"].astype(str).unique().tolist(),
        "transmissions": [t for t in df["Transmission"].astype(str).unique().tolist() if t.strip() != ""],
        "owner_types": [o for o in df["Owner_Type"].astype(str).unique().tolist() if o.strip() != ""]
    }

@app.post("/predict")
def predict_and_store(car: CarInput):
    if not os.path.exists(MODEL_PATH):
        raise HTTPException(status_code=503, detail="ML model is missing. Please execute train.py first!")
    
    try:
        model = joblib.load(MODEL_PATH)
        
        # Structure the DataFrame row exactly how your scikit-learn pipeline expects it
        input_df = pd.DataFrame([{
            "Name": car.Name,
            "Year": car.Year,
            "Kilometers_Driven": car.Kilometers_Driven,
            "Fuel_Type": car.Fuel_Type,
            "Transmission": car.Transmission,
            "Owner_Type": car.Owner_Type,
            "Engine": car.Engine,
            "Power": car.Power
        }])
        
        # Calculate the price prediction
        prediction = round(float(model.predict(input_df)[0]), 2)
        
        # Save all 8 values + output prediction to SQLite DB
        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO car_predictions (
                timestamp, name, year, kilometers_driven, fuel_type, transmission, owner_type, engine, power, predicted_price
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 
            car.Name, 
            car.Year, 
            car.Kilometers_Driven, 
            car.Fuel_Type,
            car.Transmission,
            car.Owner_Type,
            car.Engine,
            car.Power,
            prediction
        ))
        conn.commit()
        conn.close()
        
        return {"predicted_price": prediction}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))