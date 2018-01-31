import sys
import os
import subprocess
from pyspark import SparkContext
from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.types import *
from pyspark.sql.functions import *
from datetime import *

#######################################
# Setup 
#######################################
# generic client to preserve confidentiality
client = 'client'

# get previous day's date
logsdate = date.today() - timedelta(1)
logsyear = logsdate.strftime('%Y')
logsmonth = logsdate.strftime('%m')
logsday = logsdate.strftime('%d')

#######################################

spark = SparkSession\
	.builder\
	.appName("Test Job")\
	.config("spark.some.config.option", "some-value")\
	.getOrCreate()

sc = spark.sparkContext

#######################################

# clean page URL field (encoding commas)
def finalURL(page_url):
	newurl = ''
	if page_url is not None:
		newurl = page_url.replace(',','%2C')
	return newurl
udffinalURL = udf(finalURL, StringType())

# load filtered listening logs from S3
schemaString = "appName,bidTime,category,domain,environmentType,geoCountry,geoMetro,geoRegion,geoZip,inventorySource,ipAddress,platformBandwidth,platformBrowser,platformBrowserVersion,platformCarrier,platformDeviceDidmd5,platformDeviceDidsha1,platformDeviceIdfa,platformDeviceIfa,platformDeviceMake,platformDeviceModel,platformDeviceType,platformOs,platformOsVersion,userId,placementType,geoLat,geoLong,videoPlayerWidth,videoPlayerHeight,bannerWidth,bannerHeight,geoType,pageUrl"
fields = [StructField(field_name, StringType(), True) for field_name in schemaString.split(",")]
Schema = StructType(fields)
listening = spark.read.format("csv").option("header", "false").schema(Schema).load("s3://processed-logs/listening/"+logsyear+"/"+logsmonth+"/"+logsday+"/*/*.gz")
count = listening.count()
# check if any data is returned. otherwise, empty CSVs will be written as final output
if (count != 0):
	listening.createOrReplaceTempView("bwdata")

	# load sync logs
	schemaString = "logDate,trackerId,partnerId,partnerUserId"
	fields = [StructField(field_name, StringType(), True) for field_name in schemaString.split(",")]
	logSchema = StructType(fields)
	logdataSync = spark.read.format("csv").option("header", "false")\
		.option("delimiter", "\t")\
		.schema(logSchema)\
		.load("s3://apollo-sync-logs/"+logsyear+"/"+logsmonth+"/"+logsday+"/*.gz")
	logdataSync.createOrReplaceTempView("sync")

	apollo = spark.sql("SELECT bwdata.bidTime, sync.trackerId, bwdata.userId, bwdata.pageUrl FROM bwdata JOIN sync ON bwdata.userId=sync.partnerUserId WHERE category LIKE '%IAB13%' OR category LIKE '%IAB6%' OR category LIKE '%IAB9_18%' LIMIT 20000000")
	preurls = apollo.where(col("pageUrl").isNotNull())
	preurls = preurls.withColumn("pageUrl", udffinalURL("pageUrl"))
	preurls.coalesce(1).write.csv("s3n://reports/"+client_id+"/finance-details/"+logsyear+"/"+logsmonth+"/"+logsday+"/")

	grapeshot = spark.sql("SELECT DISTINCT pageUrl FROM bwdata WHERE category LIKE '%IAB13%' OR category LIKE '%IAB6%' OR category LIKE '%IAB9_18%' LIMIT 20000000")
	urls = grapeshot.where(col("pageUrl").isNotNull())
	urls = urls.withColumn("pageUrl", udffinalURL("pageUrl"))
	urls.write.csv("s3n://reports/"+client_id+"/finance-urls/"+logsyear+"/"+logsmonth+"/"+logsday+"/")

sc.stop();