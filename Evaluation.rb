#Matthew Lake, Austin Carico, Ben Rybarczyk
require 'benchmark'

def dataGen(dataSize)
    for i in 1..10 do
    #Create the testData file of unsorted integers
	outFile = File.new("testData" + i.to_s+".txt", "w")
	#Declare random number generator
	randNum = Random.new

	#Adding the data into the file
	#Every iteration will be on a new line
	for i in 1..dataSize do 
    current = randNum.rand(0..100000)
    outFile.write("#{current}\n")
	end

	#closing the file
	outFile.close
	end
end

#begin insertion sort
def InsertionSort(arr)
    comparisons = 2
    #Sort in increasing order
    for i in 1...arr.length  
        j = i 
        comparisons = comparisons + 1
        #While the current index(j) is not at the beginning of the array
        while j >= 1
            comparisons = comparisons + 1
            #If current element in array is less than previous element
        	if arr[j-1] > arr[j]
                comparisons = comparisons + 1
                temp = arr[j]
                arr[j] = arr[j-1]
                arr[j-1] = temp
            end
            #Decrement the index j
            j = j - 1
        end
    end
    #At the end push the amount of comparisons to the front of the array so we can pop it in the main and reference it
    arr.push(comparisons)
    return arr
end
#End Insertion sort

#Start Quicksort
def quicksort(arr, first, last)
    $currentQ = $currentQ + 1
    if first < last
        #Partition the array into sub arrays then sort them using recursion
        p = partition(arr, first, last)
        quicksort(arr, first, p - 1)
        quicksort(arr, p + 1, last)
    end
    return arr
end
#End Quicksort

#Begin Partition
def partition(arr, first, last)
    i = first
    j = last + 1
    pivot = arr[first]
    $currentQ = $currentQ + 2 
    while true #begin iteration of array
        begin #increment the first element's index until it crosses the last index
            i += 1
            $currentQ = $currentQ + 2
            if i == last
			    break
			end
            
        end while arr[i] < pivot #end incrementation when first element is less than pivot element
        begin #decrement the last element's index until it crosses the first index
            j -= 1
            $currentQ = $currentQ + 2
            if j == first
			    break
			end
            
        end while arr[j] > pivot #end decrementation when last element is greater pivot element
        $currentQ = $currentQ + 1
        if i >= j
		    break
		end
            
        #Swap arr[i] and arr[j]
        temp = arr[i]
        arr[i] = arr[j]
        arr[j] = temp
    end
    #Swap arr[first] with arr[j]
    temp = arr[first]
    arr[first] = arr[j]
    arr[j] = temp
    return j
end
#End Partition

def main()
	#Initialize the different data sizes used
	dataSizes = [5000,25000,50000]
	
	#Create out put files for the results 
	outputFile = File.new("outputFile.txt", "w")
    

    #Generate a new set of data with dataSize elements
	for dataSize in dataSizes
        #Call the dataGen method to generate dataSize integers
	    dataGen(dataSize)
        #Create sorted data file
	    outFile = File.new("DataSorted.txt", "w")
	
	    #Open the file with the data
	    for i in 1..10
            #Reading all the unsorted data files created by the dataGen method
	        inFile = File.new("testData" + i.to_s + ".txt", "r")
	        dataInsertion = []
            dataQuicksort = []
	        #Push each unsorted element into a array
	        inFile.each{|x| dataInsertion.push(x.to_i); dataQuicksort.push(x.to_i)}
	        #closing the file
	        inFile.close
	        #Call insertion sort and output the result to a file
	        outFile.write("Insertion Sort Set " +"#{dataSize}" + i.to_s + ":")
            #Benchmark and call Insertion sort and store the times for later accessability
	        start = Time.now
	        ret = InsertionSort(dataInsertion)
            finish = Time.now
            currentI = ret.pop() #declare comparison counter for quicksort using quicksort's comparison array
            outFile.write(ret)
	        algCPUTime = finish - start
            #Break up the output file
	        outFile.write("\n\n")

            #Benchmark and Call quicksort and output the result to a file
	        outFile.write("Quicksort Sort Set " + "#{dataSize}" +i.to_s + ":")
            $currentQ = 0 #declare comparison counter for quicksort
            start = Time.now
	        outFile.write(quicksort(dataQuicksort,0,dataQuicksort.length-1))
            finish = Time.now
            
	        algCPUTime2 = finish - start

            #Break up the output file
	        outFile.write("\n\n")
            
            #Print the comparisons to console for reference
            puts dataSize
	        puts "The number of Insertion comparisons is #{currentI}"
	        puts "The number of Quicksort comparisons is #{$currentQ}"
	        

            #Creating values for the theretical worst comparisons
            theoreticalWorst = dataSize * dataSize
            
            #Output findings to the output file
            outputFile.write("I, Dataset " + i.to_s + ", #{dataSize}, " + currentI.to_s + ", #{algCPUTime}, #{theoreticalWorst.round()} \n")
	        outputFile.write("Q, Dataset " + i.to_s + ", #{dataSize}, " + $currentQ.to_s + ", #{algCPUTime2}, #{theoreticalWorst.round()} \n")
	    end
    end
end 

#Call the main function
main()
