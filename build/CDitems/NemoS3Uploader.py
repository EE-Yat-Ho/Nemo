# -*- coding: utf-8 -*-
# 한글 써져있는것 encoding
import boto3
import os
import plistlib
import sys
import json
from datetime import datetime
from botocore.exceptions import ClientError

jenkinsDirectory = str(sys.argv[1])
bucketName = "nemo-cd"
appName = "Nemo"
appImageName = "NemoAppIcon.png" # S3 최상단에 넣기, 확장자까지 써주시기
today = datetime.now()
date = today.strftime("%Y%m%d-%H%M%S")

def uploadFile_s3_bucket(date):
    # AWS 연결
    client = boto3.client(
        's3',  # 사용할 서비스 이름, ec2이면 'ec2', s3이면 's3', dynamodb이면 'dynamodb'
        aws_access_key_id = "",     # 액세스 ID
        aws_secret_access_key = ""  # 비밀 엑세스 키
    )
    
    # MARK:- manifest ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    # 젠킨스의 manifest 경로 찾기
    manifestFileDir = ""
    if os.path.exists(jenkinsDirectory + "manifest.plist"):
        manifestFileDir = jenkinsDirectory + "manifest.plist"
    else :
        print("manifest FILE NOT EXIST")
        
    # manifest 파일 읽기
    fin = open(manifestFileDir, "rt")
    data = fin.read()
    fin.close()
    
    # manifest에서 Build 버전 정보 추출하기
    keyBegin = data.find("bundle-version")
    versionBegin = keyBegin + 33
    buildVersionStr = ""
    for i  in range(100):
        if data[versionBegin + i] == '<':
            break
        buildVersionStr = buildVersionStr + data[versionBegin + i]
    
    # manifest가 가르키는 ipa 경로 바꾸기
    fin = open(jenkinsDirectory+"newManifest.plist", "wt")
    data = data.replace("pleaseWriteAppURL",
                        "https://"+bucketName+".s3.ap-northeast-2.amazonaws.com/build"+buildVersionStr+"_time"+date+"/"+appName+".ipa")
    data = data.replace("pleaseWriteDisplayAppImageURL",
                        "https://"+bucketName+".s3.ap-northeast-2.amazonaws.com/"+appImageName)
    data = data.replace("pleaseWriteFullSizeAppImageURL",
                        "https://"+bucketName+".s3.ap-northeast-2.amazonaws.com/"+appImageName)
    fin.write(data)
    fin.close()
    
        
    # MARK:- IPA ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    # 젠킨스의 IPA 경로 찾기
    ipaFileDir = ""
    if os.path.exists(jenkinsDirectory + appName + ".ipa"):
        ipaFileDir = jenkinsDirectory + appName + ".ipa"
    else :
        print("IPA FILE NOT EXIST")
        
    # MARK:- Json ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    localJsonFileDir = jenkinsDirectory + appName + "IpaList.json" # S3에서 다운받을 JSON 파일의 저장 경로
    S3JsonFileDir = appName + "IpaList.json" # S3 내에서 JSON 파일 경로
    
    try: # S3에 JSON 파일이 있음
        client.download_file(bucketName, S3JsonFileDir, localJsonFileDir) # 다운로드 실패시 except로.
        file = open(localJsonFileDir, "r") # file
        dict = json.load(file) # file -> dict
        file.close()
        newIpa = {
            "buildVersion" : buildVersionStr,
            "time" : date
        }
        dict["ipas"].append(newIpa)
        with open(localJsonFileDir, "w") as f:
            trash = json.dump(dict, f, indent=4)
    except: # S3에 JSON 파일이 없음
        dict = {
            "ipas" : [
                {
                    "buildVersion" : buildVersionStr,
                    "time" : date
                }
            ]
        }
        with open(localJsonFileDir, "w") as f:
            trash = json.dump(dict, f, indent=4)
    
    
    # MARK :- 업로드는 다 잘됐을 때 한번에 하기 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    # Smanifest 파일 올리기
    response = client.upload_file(jenkinsDirectory+"newManifest.plist",
                                  bucketName,
                                  "build"+buildVersionStr+"_time"+date+"/manifest.plist",
                                  ExtraArgs={'ACL': 'public-read'})
    # IPA 파일 올리기
    response2 = client.upload_file(ipaFileDir,
                                  bucketName, # 버킷 이름
                                  "build"+buildVersionStr+"_time"+date+"/"+appName+".ipa",
                                  ExtraArgs={'ACL': 'public-read'})
    # Json 파일 올리기
    response3 = client.upload_file(localJsonFileDir,
                                  bucketName,
                                  S3JsonFileDir,
                                  ExtraArgs={'ACL': 'public-read'})
                                  
    if str(response) == "None" and str(response2) == "None" and str(response3) == "None":
        print("UPLOAD COMPLETED")
    else :
        print("UPLOAD ERROR")

uploadFile_s3_bucket(date)
