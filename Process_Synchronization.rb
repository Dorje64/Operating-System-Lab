##############################
##Process Synchronization
##
##Torchi Rokaya
##############################

$Q=[]
$i=0
$QSIZE = 5
class Proces
attr_accessor:brust_t, :name, :arv_t
   def initialize(bt,na,i)
      @brust_t=bt
      @name=na
      @arv_t=i
      $Q<<self
   end
end


def Producer
	while true
		if ($Q.length < $QSIZE)
			@bursttime = rand(10) + 1
			Proces.new(@bursttime, "prc#{$i}", 0)
			puts "New Process prc#{$i} with  Brusttime #{@bursttime}  is added to Queue"
			$i += 1
	#		puts "New Process  #{@bursttime} added to queue"
		else
			puts "QUEUE FULL"
		end
		sleep(rand(5))
	end
end

def Teller1
	while (true)
		if (!$Q.empty?)
	      pr =  $Q.shift
	      if(pr!=nil)
	         puts "#{pr.name}  with  brust Time #{pr.brust_t} is in Teller1 #{Time.now}"
	         sleep(pr.brust_t)
	         puts "#{pr.name} completed and Teller1 is free now"
	      end
	  end
	  sleep(1)
	end
end

def Teller2
	while (true)
		if (!$Q.empty?)
	      pr =  $Q.shift
	      if(pr!=nil)
	         puts "#{pr.name}  with BrustTime #{pr.brust_t} is in Teller2 #{Time.now}"
	         sleep(pr.brust_t)
	         puts "#{pr.name} completed and Teller2 is free now"
	      end
	  end
	  sleep(1)
	end
end


def schedular
			puts "Started At #{Time.now}"
		  #  puts "Teller no    process name    brust time     Time"
			producer = Thread.new{Producer()}
			t1=Thread.new{Teller1()}
			t2=Thread.new{Teller2()}
			producer.join
			t1.join
			t2.join
			#puts "End at #{Time.now}"
end
schedular