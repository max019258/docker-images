# docker-images

도커를 실행하기 위하여 wsl2 설치 <br>
![image](https://user-images.githubusercontent.com/71125201/176615561-2a0cc278-13b7-4982-ad68-472087a885c5.png) <br>

<h2> 도커로 오라클 작동 시키기 </h2> <br>
1. 도커 허브에 등록된 오라클 이미지 검색 <br>
$ docker login <br>
$ docker search oracle <br>
![image](https://user-images.githubusercontent.com/71125201/176615890-fe375a13-ae0a-4c57-8de2-7e3e631241f5.png) <br>

2. 다운로드 받은 oracle 11g로 docker container를 생성하여 설치 <br>
$	docker pull jaspeen/oracle-11g  //다운  <br>
$	docker run --name oracle11g -d -p 1521:1521 jaspeen/oracle-xe-11g  //실행or없으면 다운 <br>
$	docker ps -a		// 컨테이너 확인 <br>
$	docker exec -it oracle11g sqlplus // 실행 <br>

user-name: system <br>
password : oracle <br>

3. 오라클이 설치된 컨테이너의 타임존 변경 후 scott 계정 활성화 <br>
$	sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime 	// Ubuntu에 /etc/localtime로 링크 <br>
$	 docker run --name oracle11g -d -p 1521:1521 jaspeen/oracle-xe-11g -v /etc/localtime:/etc/localtime:ro \ -e TZ=Asia/Seoul 	 <br>
$	docker exec -it oracle11g sqlplus			// oracle 11g에 있는 sqlplus 실행 <br>
SQL> : @ ?/rdbms/admin/utlsampl.sql  		//scott계정 생성 <br>

4. oracle이 설치된 컨테이너의 현재상태로 새로운 이미지  생성 <br>
$ docker commit oracle11g oracle11g_2  //container oracle11g를 oracle11g_2라는 이름의 이미지로 commit <br>
![image](https://user-images.githubusercontent.com/71125201/176616963-1b4e53ea-a977-42c7-9358-86f45632093b.png) <br>

<h2> 도커로 python SimpleHTTPServer 작동 </h2> <br>
1.	alpine linux를 백그라운드로 실행 <br>
$ docker run -d -it --name alpine alpine <br>
![image](https://user-images.githubusercontent.com/71125201/176617466-0e192464-ec23-4f41-9a65-57f8b94da62e.png) <br>

2. 실행중인 container의 쉘(sh)을 실행하고 터미널로 접속 <br>
$ docker exec -it alpine /bin/sh <br>

3. 터미널 접속후 타임존 설치 후 변경 <br>
$ apk add tzdata 	//  tzdata  다운 <br>
$ cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime		// Asia//Seoul을 localtime에 넣는다. <br>

4. python을 apk로 설치 <br>
$ apk add python2 <br>

5. “/www” 디렉토리를 만들고 /www 이동후 python SimpleHTTPServer 를 실행 <br>
$ docker commit alpine alpine2   		// 포트 포워딩을 위해 지금까지 한내용 commit			 <br>
$ docker run --name alpine2 -d -it -p 8000:8000 alpine2	// 8000:8000으로 포트 포워딩,컨테이너 이름: alpine2 -i <br>
$ docker ps -a				// 포워딩확인을 위한 컨테이너 목록 조회 <br>
$ docker exec -it alpine2 sh			// alpine2 터미널 실행 <br>
$ mkdir www				// www 디렉토리 생성 <br>
$ cd www 				// 이동 <br>
$  python -m SimpleHTTPServer 8000		// 8000번 웹서버 구동 <br>

6. 지금까지 한 내용 도커 파일로 생성 <br>
$ mkdir docker <br>
$ cd docker <br>
$ vim Dockerfile <br>
-------도커파일 내용------ <br>
FROM alpine <br>

RUN apk add tzdata <br>
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime <br>
RUN apk add python2 <br>
RUN mkdir www <br>
RUN cd www <br>
EXPOSE 8000 <br>
CMD ["python", "-m", "SimpleHTTPServer", "8000"] ### 컨테이너로 올라갈시 실행 <br>

7. Dockerfile로 image를 빌드하고 빌드된 이미지로 새로운 container를 실행 <br>
$ docker build -t df:v1 . 		//현재 디렉토리의 도커파일을 df:v1라는 이름으로 이미지화 <br>
$ docker run --name alpine3 -it -d -p 8000:8000 df:v1 // 이미지 컨테이너로 만들기 <br>
