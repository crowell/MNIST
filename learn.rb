require 'ai4r'
require 'yaml'

l = IO.read "./nntrain.nn"
l = l.split "\n"

doc = l.shift
doc = doc.split(" ").collect{|x| x.to_i}
puts "learning from #{doc[0]} inputs of #{doc[1]} outputs of #{doc[2]}"

inp = []
outp = []
i = 0
l.each{|line|
	a = line.split(" ").collect{|x| x.to_f}
	if i == 0
		inp << a
		i = 1
	else
		outp << a
		i = 0
	end
}

puts "lets learn!"
# 1 hidden layer with 30 nodes
net = Ai4r::NeuralNetwork::Backpropagation.new([doc[1], 30, doc[2]])

5.times{|i|
	inp.each_with_index{|x,j|
		error = net.train(x, outp[j])
		puts "error after iteration #{i},#{j}:\t#{error}" if j % 100 == 0
		if j == 100
			break
		end
	}
}

IO.write('out.nn', Marshal.dump(net))
net = "lol"
net = Marshal.load (IO.read('out.nn'))

l = IO.read "./nntest.nn"
l = l.split "\n"

doc = l.shift
doc = doc.split(" ").collect{|x| x.to_i}
puts "testing from #{doc[0]} inputs of #{doc[1]} outputs of #{doc[2]}"

inp = []
outp = []
i = 0
l.each{|line|
    a = line.split(" ").collect{|x| x.to_f}
    if i == 0
        inp << a
        i = 1
    else
        outp << a
        i = 0
    end
}

def out_to_str(arr)
	max = arr[0]
	maxidx = 0
	arr.each_with_index{|i,x|
		if i > max
			maxidx = x
			max = i
		end
	}
	return maxidx
end

correct_count = 0
inp.each_with_index{|x,j|
	gt =  out_to_str(outp[j])
	guess = out_to_str(net.eval(x))
	if gt == guess
		correct_count = correct_count + 1
	end
	if j % 100 == 0
		puts "#{correct_count} / #{j}"
	end
}
puts correct_count
