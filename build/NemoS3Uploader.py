# -*- coding: utf-8 -*-
# 한글 써져있는것 encoding
import boto3
import os
import plistlib
import sys
from datetime import datetime
from botocore.exceptions import ClientError

jenkinsDirectory = str(sys.argv[1])
# buildVersion = str(sys.argv[2])
print("HERE IS iPA DIRECTORY & BUILD VERSION")
print(jenkinsDirectory) #, buildVersion)

def modifyManifest(manifestFileDir, date):
    # 매니페스트 파일 열기
    fin = open(directory, "rt")
    data = fin.read()

    #replace all occurrences of the required string
    data = data.replace('https://kkpoint-ios.s3.ap-northeast-2.amazonaws.com/kkpoint-oven.ipa',
                        'https://kkpoint-ios.s3.ap-northeast-2.amazonaws.com/{}-{}/kkpoint-oven.ipa'.format(buildVersion, date))
    #close the input file
    fin.close()
    #open the input file in write mode
    fin = open(directory, "wt")
    #overrite the input file with the resulting data
    fin.write(data)
    #close the file
    fin.close()

def uploadFile_s3_bucket(date):
    client = boto3.client(
        's3',  # 사용할 서비스 이름, ec2이면 'ec2', s3이면 's3', dynamodb이면 'dynamodb'
        aws_access_key_id="",     # 액세스 ID
        aws_secret_access_key=""  # 비밀 엑세스 키
    )
    
    # 젠킨스의 manifest 경로 찾기
    manifestFileDir = ""
    if os.path.exists(jenkinsDirectory + "manifest.plist"):
        manifestFileDir = jenkinsDirectory + "manifest.plist"
        
    # 젠킨스의 manifest 내용 수정하기
    modifyManifest(manifestFileDir, date)
    
    # 젠킨스의 ipa 경로 찾기
    ipaFileDir = ""
    if os.path.exists(jenkinsDirectory + "Nemo.ipa"):
        ipaFileDir = jenkinsDirectory + "Nemo.ipa"
        
    else :
        print("FILE NOT EXIST")
    
    # S3에 ipa 파일 올리기
    response = client.upload_file(ipaFileDir, # 젠킨스 ipa 경로
                                  "nemo-cd", # 버킷 이름
                                  "{}/Nemo.ipa".format(date), #"NemoIpa-{}/Nemo.ipa".format(date), # 버킷 내의 경로
                                  ExtraArgs={'ACL': 'public-read'})
    # S3에 manifest 파일 올리기
    response2 = client.upload_file(manifestFileDir,
                                  "nemo-cd",
                                  "{}/manifest.plist".format(date), #.format(buildVersion, date),
                                  ExtraArgs={'ACL': 'public-read'})
    
    if str(response) == "None" and str(response2) == "None" :
        print("UPLOAD COMPLETED")
    else :
        print("UPLOAD ERROR")

today = datetime.now()
date = today.strftime("%Y%m%d-%H:%M:%S")
uploadFile_s3_bucket(date)

