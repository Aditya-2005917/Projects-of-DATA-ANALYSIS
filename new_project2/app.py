import streamlit as st
import requests

API_URL = "http://127.0.0.1:8000"

st.set_page_config(page_title="Car Pricing Engine", page_icon="🚗", layout="centered")
st.title("🚗 Used Car Pricing Valuation Engine")

# --- FETCH ENRICHED METADATA FROM FASTAPI ---
try:
    meta_response = requests.get(f"{API_URL}/meta").json()
    names = meta_response["names"]
    years = meta_response["years"]
    fuels = meta_response["fuel_types"]
    transmissions = meta_response["transmissions"]
    owners = meta_response["owner_types"]
except Exception:
    st.error("Cannot contact your FastAPI backend. Please make sure your Uvicorn server is running.")
    st.stop()

# --- RENDER THE INTERACTIVE INPUT FORM ---
with st.form("valuation_form"):
    st.write("Specify vehicle parameters below to get an accurate estimation:")
    
    selected_name = st.selectbox("Select Car Make & Model Name", options=names)
    
    # Split primary specifications into two visual columns
    col1, col2 = st.columns(2)
    with col1:
        selected_year = st.selectbox("Model Production Year", options=years)
        selected_kms = st.number_input("Odometer (Total Kilometers Driven)", min_value=0, max_value=2000000, value=30000, step=2500)
        selected_fuel = st.selectbox("Engine Fuel Type", options=fuels)
    with col2:
        selected_trans = st.selectbox("Gearbox Transmission Type", options=transmissions)
        selected_owner = st.selectbox("Current Ownership History Status", options=owners)
        
    st.markdown("---")
    st.write("**Engine Performance Specs**")
    
    # Split technical specifications into two visual columns
    col3, col4 = st.columns(2)
    with col3:
        selected_engine = st.number_input("Displacement Volume Size (in CC)", min_value=100, max_value=8000, value=1197, step=100)
    with col4:
        selected_power = st.number_input("Maximum Horsepower Output (in bhp)", min_value=10.0, max_value=1000.0, value=88.5, step=5.0)
    
    submit = st.form_submit_button("Calculate Estimated Value")

# --- SEND 8-PARAMETER PAYLOAD TO API ---
if submit:
    payload = {
        "Name": str(selected_name),
        "Year": int(selected_year),
        "Kilometers_Driven": int(selected_kms),
        "Fuel_Type": str(selected_fuel),
        "Transmission": str(selected_trans),
        "Owner_Type": str(selected_owner),
        "Engine": float(selected_engine),
        "Power": float(selected_power)
    }
    
    with st.spinner("Processing live algorithmic model calculation..."):
        res = requests.post(f"{API_URL}/predict", json=payload)
        if res.status_code == 200:
            predicted_price = res.json()["predicted_price"]
            
            # Converts Lakhs to a clear, full-format Indian Rupee total
            full_rupees = int(predicted_price * 100000)
            st.success(f"### Estimated Value: ₹{full_rupees:,} INR")
            st.caption("ℹ️ Model calculations are processed using your enriched 8-feature dataset pipeline.")
        else:
            st.error(f"Error from API server pipeline: {res.json().get('detail')}")