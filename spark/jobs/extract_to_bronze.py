from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("extract_to_bronze").master("spark://spark-master:7077").getOrCreate()

path = "/opt/data/bronze/"
                    
raw_data = {
    "patients":"1_patients.csv",
    "ed_visits_and_operations":"2_ed_visits_and_operations.csv",
    "vital_signs":"3_vital_signs.csv",
    "laboratory_results":"4_laboratory_results.csv",
    "diagnosis_notes_meds":"5_diagnosis_notes_meds.csv",
    "patient_outcomes":"6_patient_outcomes.csv",
    "er_master_training_dataset":"er_master_training_dataset.csv",
    "er_sample_data":"er_sample_data.csv"
            }

for name, file in raw_data.items():

    try:
        print(f"Starting ingestion for {file}...")

        df = spark.read.format("csv") \
            .option("inferSchema", "true") \
            .option("header", "true") \
            .load(path + file)

        print(f"Reading {file} from bronze layer ✅")

        df.write.format("parquet") \
            .mode("overwrite") \
            .save(f"/opt/data/silver/{name}")

        print(f"Ingestion {name} into silver layer ✅")

    except Exception as e:
        print(f"Ingestion failed for {file} ❌")
        print(f"Error: {str(e)}")

        continue

spark.stop()
print("Data ingestion completed in silver layer successfully.✅")