import requests
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.ensemble import RandomForestRegressor
from sklearn.pipeline import Pipeline
import joblib

API_URL = "http://127.0.0.1:8000/data"
print("Connecting to live backend data stream...")

try:
    response = requests.get(API_URL)
    df = pd.DataFrame(response.json())
except Exception as e:
    print(f"Error: Couldn't fetch data from API ({e}). Make sure your Uvicorn server is running!")
    exit()

# --- NEW: ADVANCED DATA CLEANING ---
print("Cleaning engineering text units from numeric columns...")

# 1. Strip ' CC' out of Engine and convert to numeric decimal values
if "Engine" in df.columns:
    df['Engine'] = df['Engine'].astype(str).str.replace(' CC', '', case=False).str.strip()
    df['Engine'] = pd.to_numeric(df['Engine'], errors='coerce')
    # Fill missing values with the median engine size
    df['Engine'] = df['Engine'].fillna(df['Engine'].median())

# 2. Strip ' bhp' out of Power and convert to numeric decimal values
if "Power" in df.columns:
    df['Power'] = df['Power'].astype(str).str.replace(' bhp', '', case=False).str.strip()
    df['Power'] = pd.to_numeric(df['Power'], errors='coerce')
    # Fill missing values with the median power output
    df['Power'] = df['Power'].fillna(df['Power'].median())

# --- SELECT FEATURES AND TARGET ---
# Include all the high-weight features now that they are cleaned up
X = df[["Name", "Year", "Kilometers_Driven", "Fuel_Type", "Transmission", "Owner_Type", "Engine", "Power"]]
y = pd.to_numeric(df["Price"], errors='coerce')

# Drop rows where the target price is missing or corrupt in the dataset
valid_idx = y.notna()
X = X[valid_idx]
y = y[valid_idx]

# --- PIPELINE PREPROCESSING ---
# 'Name', 'Fuel_Type', 'Transmission', and 'Owner_Type' get One-Hot Encoded.
# 'Year', 'Kilometers_Driven', 'Engine', and 'Power' bypass automatically as numbers!
categorical_features = ["Name", "Fuel_Type", "Transmission", "Owner_Type"]
categorical_transformer = OneHotEncoder(handle_unknown="ignore")

preprocessor = ColumnTransformer(
    transformers=[
        ("cat", categorical_transformer, categorical_features)
    ], 
    remainder="passthrough"
)

# --- WORKFLOW OBJECT PIPELINE ---
pipeline = Pipeline(steps=[
    ("preprocessor", preprocessor),
    ("regressor", RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1))
])

print("Training Random Forest valuation model on enriched dataset columns...")
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
pipeline.fit(X_train, y_train)

score = pipeline.score(X_test, y_test)
print(f"\n🚀 Model Training Complete! New R-squared accuracy score: {score:.2f}")

# Save the compiled asset
joblib.dump(pipeline, "car_model.joblib")
print("Saved complete pipeline mapping asset to 'car_model.joblib'")