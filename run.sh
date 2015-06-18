#!/bin/bash

salida=threads_sockets_relation.csv
MAX_PACKS=10000
repetitions=4
total_threads="1 2 4 8"
total_sockets="1 2 3"
total_clients=4

echo "Compilando..."
make all
echo "Done"

echo "Ejecutando Prueba..."
for num_sockets in $total_sockets
do
	linea=$num_sockets";"

	#Definir aqui el límite de Threads
	for num_threads in $total_threads
	do
		echo "Evaluando "$num_threads" Threads accediendo a "$num_sockets" Sockets"
		for ((i=1 ; $i<=$repetitions ; i++))
		{
 			if(($num_threads < $num_sockets))
 			then
 				echo "No se puede Evaluar"
 				linea=$linea"0, "
 			else
 				echo "Repeticion "$i
 				./server $MAX_PACKS $num_threads $num_sockets > aux &
 				pid=$!
 				sleep 1

				for ((j=1 ; $j<=$total_clients ; j++))
				{
					./client $(($MAX_PACKS*10)) $num_sockets 127.0.0.1 > /dev/null &
				}

 				wait $pid
 				linea="$linea$(cat aux)"
 				rm aux
 			fi
		}
		linea="$linea;"
 		echo ""
	done
	echo "$linea" >> $salida
done

make clean
echo "Done"

#python postProcessing.py $salida



# salida=threads_sockets_relation.csv
# MAX_PACKS=10000
# repetitions=4

# echo "Compilando..."
# make all
# echo "Done"

# echo "Ejecutando Prueba..."

# #Definir aquí el límite de sockets
# for num_sockets in {1..3}
# do
# 	linea=$num_sockets";"

# 	#Definir aqui el límite de Threads
# 	for ((num_threads=1 ; $num_threads<=5 ; num_threads++))
# 	{
# 		echo "Evaluando "$num_threads" Threads y con "$num_sockets" Sockets"
# 		for ((i=1 ; $i<=$repetitions ; i++))
# 		{
# 			if(($num_threads < $num_sockets))
# 			then
# 				echo "No se puede Evaluar"
# 				linea=$linea"0, "
# 			else
# 				echo "Repeticion "$i
# 				./server $MAX_PACKS $num_threads $num_sockets > aux &
# 				pid=$!
# 				sleep 1

# 				./client $(($MAX_PACKS*10)) $num_sockets 127.0.0.1 > /dev/null &
# 				./client $(($MAX_PACKS*10)) $num_sockets 127.0.0.1 > /dev/null &
# 				./client $(($MAX_PACKS*10)) $num_sockets 127.0.0.1 > /dev/null &
# 				./client $(($MAX_PACKS*10)) $num_sockets 127.0.0.1 > /dev/null &
# 				wait $pid
# 				linea="$linea$(cat aux)"
# 				rm aux
# 			fi
# 		}
# 		linea="$linea;"
# 		echo ""
# 	}
# 	echo "$linea" >> $salida
# done
# make clean
# echo "Done"

# python postProcessing.py $salida