from flask import Flask, request, jsonify
import pandas as pd
import joblib

# Load model dan scaler
model = joblib.load('model_lung.pkl')
scaler = joblib.load('scaler_lung.pkl')

# Nama-nama kolom yang digunakan saat training (copy dari data asli)
TRAINING_COLUMNS = [
    "GENDER", "AGE", "SMOKING", "YELLOW_FINGERS", "ANXIETY", "PEER_PRESSURE",
    "CHRONIC DISEASE", "FATIGUE ", "ALLERGY ", "WHEEZING", "ALCOHOL CONSUMING",
    "COUGHING", "SHORTNESS OF BREATH", "SWALLOWING DIFFICULTY", "CHEST PAIN"
]

# Inisialisasi Flask
app = Flask(__name__)

@app.route('/predict_lung_cancer', methods=['POST'])
def predict_lung_cancer():
    try:
        data = request.get_json()

        # Ubah ke DataFrame
        input_df = pd.DataFrame([data])

        # Ubah nama kolom agar sama persis dengan saat training
        rename_map = {
            'ALCOHOL_CONSUMING': 'ALCOHOL CONSUMING',
            'CHEST_PAIN': 'CHEST PAIN',
            'CHRONIC_DISEASE': 'CHRONIC DISEASE',
            'SHORTNESS_OF_BREATH': 'SHORTNESS OF BREATH',
            'SWALLOWING_DIFFICULTY': 'SWALLOWING DIFFICULTY'
        }
        input_df.rename(columns=rename_map, inplace=True)

        # Pastikan kolom urutannya sesuai
        input_df = input_df[TRAINING_COLUMNS]

        # Normalisasi
        input_scaled = scaler.transform(input_df)

        # Prediksi
        prediction = model.predict(input_scaled)[0]
        confidence = model.predict_proba(input_scaled)[0][prediction]

        return jsonify({
            'prediction': 'Negatif Kanker Paru' if prediction == 1 else 'Positif Kanker Paru',
            'confidence': round(confidence * 100, 2)
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)