all: server client

all_profiling: serverProfiling client

server: server.o ../ssocket/ssocket.o
	gcc -o3 server.o ../ssocket/ssocket.o -o server -lpthread

serverProfiling: server.o ../ssocket/ssocket.o
	gcc -fno-omit-frame-pointer -ggdb server.o ../ssocket/ssocket.o -o server -lpthread

rm_server:
	rm server server.o

client: client.o ../ssocket/ssocket.o
	gcc -o3 client.o ../ssocket/ssocket.o -o client -lpthread

rm_client:
	rm client client.o

rm_ssocket:
	rm ../ssocket/ssocket.o

clean: rm_client rm_server rm_ssocket