# docker-images

도커를 실행하기 위하여 wsl2 설치
![image](https://user-images.githubusercontent.com/71125201/176615561-2a0cc278-13b7-4982-ad68-472087a885c5.png)

<h2> 도커로 오라클 작동 시키기 </h2>
1. 도커 허브에 등록된 오라클 이미지 검색
$ docker login
$ docker search oracle
![image](https://user-images.githubusercontent.com/71125201/176615890-fe375a13-ae0a-4c57-8de2-7e3e631241f5.png)

2. 다운로드 받은 oracle 11g로 docker container를 생성하여 설치
$	docker pull jaspeen/oracle-11g  //다운 
$	docker run --name oracle11g -d -p 1521:1521 jaspeen/oracle-xe-11g  //실행or없으면 다운
$	docker ps -a		// 컨테이너 확인
$	docker exec -it oracle11g sqlplus // 실행

user-name: system
password : oracle

3. 오라클이 설치된 컨테이너의 타임존 변경 후 scott 계정 활성화
$	sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime 	// Ubuntu에 /etc/localtime로 링크
$	 docker run --name oracle11g -d -p 1521:1521 jaspeen/oracle-xe-11g -v /etc/localtime:/etc/localtime:ro \ -e TZ=Asia/Seoul 	
$	docker exec -it oracle11g sqlplus			// oracle 11g에 있는 sqlplus 실행
SQL> : @ ?/rdbms/admin/utlsampl.sql  		//scott계정 생성

4. oracle이 설치된 컨테이너의 현재상태로 새로운 이미지  생성
$ docker commit oracle11g oracle11g_2  //container oracle11g를 oracle11g_2라는 이름의 이미지로 commit
