# Apache Spark with Python

During the last few months of my work at Anomaly, I was put in charge of completing tasks that required me to learn Spark using Python, and Amazon Web Services' S3 and EMR. We stored incoming and processed data in S3 and then retrieved the data and analyzed it using Spark scripts that were run on server clusters started by EMR.

I wrote the script entitled final_urls when my assigned task was to gather two lists:
    - one list of different details (bid time, our ID for user, data partner's ID for user, URL) related to each URL associated with finance categories (IAB6, IAB9_18, and IAB13)
    - one list of all the unique finance URLs
