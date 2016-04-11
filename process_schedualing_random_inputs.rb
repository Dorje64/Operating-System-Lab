############################
##process schedualing
##
##Torchi Rokaya
###############################
		
		$completed=[]
		$readyQ=[]
		$current_process=nil
		$raw_process=[]
		$all_pr=[]
		$time=0;
		data_arv=[]
		data_exc=[]
		data_name=[]
		$q=3	
		$a

		

class Prcs
	attr_accessor :at, :st, :wt, :name ,:turn_around
	attr_accessor :first_ent, :paused_time, :st1 ,:last_time ,:time_gap 

	def initialize(at,st,name)
		#puts "data initialize"
		puts "process #{name} =>  #{at} , #{st} "
		@name=name
		@at,@st,@st_completed,@turn_around,@paused_time=at,st,0,0,0
		@time_gap , @last_time= 0,0 
		@wt=0
		@first_ent,@responce_time,@st1=false,0,st
		$all_pr << self

	end


end


#puts $all_pr.length

class FCFS  
	def semu
		if $all_pr.empty? == true
			return 
		else
			for pr in $all_pr do 
				pr.wt=$time-pr.at

				if(pr.wt<0)
					$time+=(pr.at-$time)
					pr.wt=0
				end

				pr.turn_around=pr.wt + pr.st

				$time+=pr.st
			#	puts "#{$time}"
			end

		end
	end

	def show
		@avg_waiting_time,@avg_turnaround_time,@total_ta,@total_wt=0,0,0,0
		for pr in $all_pr
			@total_wt+=pr.wt
			@total_ta+=pr.turn_around
		end

		@avg_waiting_time =@total_wt/$all_pr.length
		@avg_turnaround_time=@total_ta/$all_pr.length

		puts "avg_waiting_time= #{@avg_waiting_time}"
		puts "avg_turnaround_time= #{@avg_turnaround_time}" 
	end
end

#------sjf-----
class SJF
	def semu
		$raw_process=$all_pr
		
		$raw_process.sort! {|a ,b| a.st <=> b.st}
		
		for pr in $raw_process
			pr.wt=$time-pr.at

				if(pr.wt<0)
					#$time+=(pr.at-$time)
					pr.wt=0
				end

				pr.turn_around=pr.wt + pr.st

				$time+=pr.st
		end	
	end

	def show
		$all_pr.sort!{|a,b| a.name <=> b.name}		
		@avg_waiting_time,@avg_turnaround_time,@total_ta,@total_wt=0,0,0,0
		for pr in $all_pr
			@total_wt+=pr.wt
			@total_ta+=pr.turn_around
		end
		@avg_waiting_time =@total_wt/$all_pr.length
		@avg_turnaround_time=@total_ta/$all_pr.length

		puts "avg_waiting_time= #{@avg_waiting_time}"
		puts "avg_turnaround_time= #{@avg_turnaround_time}" 

	end
end


class RR
	
	def semu

		for p in $all_pr
			$raw_process<<p
			#puts "#{p.name}"
		end 

		$raw_process.sort! {|a,b| a.at <=> b.at}

	while $completed.length < $all_pr.length do
 			
 			$time += 3
 			@time_beg = $time-3
 			@count=0
				while ( $raw_process.length>0 && $time > $raw_process[0].at)	
								@a=$raw_process.shift
								$readyQ<<@a
						#		puts "#{@a.name}"
						end
					

					if (!$readyQ.empty?)
						$current_process=$readyQ.shift
						$current_process.st=$current_process.st-3
					
						if($current_process.first_ent == false)
						$current_process.wt=@time_beg-$current_process.at
		#				puts "#{$current_process.name} #{@time_beg}"
					
						$current_process.first_ent=true
						end
						

						if($current_process.st>0)
							$readyQ<<$current_process

							if ($current_process.paused_time != 0)
								$current_process.wt += (@time_beg - $current_process.paused_time)
							end
						$current_process.paused_time = $time
						#puts "#{$current_process.name} #{@time_beg}"


						#	puts "#{$current_process.name}"
						else
							$time=$time+$current_process.st
							if ($current_process.paused_time != 0)
								$current_process.wt += (@time_beg - $current_process.paused_time)
							end
							$completed<<$current_process
#							

						end
					end
		
	end
	
end	

def show
		puts "-----------------------------"
			@avg_waiting_time,@avg_turnaround_time,@total_ta,@total_wt=0,0,0,0
		for pr in $all_pr
			pr.turn_around=pr.wt+pr.st1
			@total_wt+=pr.wt
			@total_ta+=pr.turn_around
		end
		@avg_waiting_time =@total_wt/$all_pr.length
		@avg_turnaround_time=@total_ta/$all_pr.length

		puts "avg_waiting_time= #{@avg_waiting_time}"
		puts "avg_turnaround_time= #{@avg_turnaround_time}" 

end


end


class SRT

	def semu
		for pr in $all_pr
			$raw_process<<pr
			#puts "#{pr.name}"
		end

		$raw_process.sort! {|a,b| a.at<=>b.at}

		while ($completed.length < $all_pr.length)

			while ( !$raw_process.empty? && $raw_process[0].at == $time)
			#	puts "#{$time} ma #{$raw_process[0].name} chiryo"
				$readyQ<<$raw_process.shift
			end

			$readyQ.sort! {|a,b| a.st<=>b.st}

			if(!$readyQ.empty?)
				$current_process=$readyQ.shift
				$current_process.st = $current_process.st-1
				print "#{$current_process.name} "

					$current_process.time_gap=$time- $current_process.last_time
					$current_process.last_time = $time
					


				if ($current_process.first_ent==false)
					$current_process.wt=$time-$current_process.at
					$current_process.first_ent=true

				elsif ($current_process.time_gap >1 )
					$current_process.wt += ($current_process.time_gap-1)
				end

				if($current_process.st > 0)
					$readyQ.insert(0,$current_process)
				else
					$completed<<$current_process
				end
			end
		
		$time+=1
		
		
		end
		puts "\n"

end


def show
		puts "-----------------------------"
			@avg_waiting_time,@avg_turnaround_time,@total_ta,@total_wt=0,0,0,0
		for pr in $all_pr
			pr.turn_around=pr.wt+pr.st1
			@total_wt+=pr.wt
			@total_ta+=pr.turn_around
		end
		@avg_waiting_time =@total_wt/$all_pr.length
		@avg_turnaround_time=@total_ta/$all_pr.length

		puts "avg_waiting_time= #{@avg_waiting_time}"
		puts "avg_turnaround_time= #{@avg_turnaround_time}" 

	end
end


puts "enter number of process"
@n=gets.to_i
 for i in 0..@n
 	data_arv<<rand(10)
 	data_exc<<rand(15) + 1
 	data_name<<"p#{i}"
end
	

@zz=0

while (@zz < 4)
p=[]
 for i in 1..@n
 	p[i] =Prcs.new(data_arv[i],data_exc[i],data_name[i])
 #	puts "input sample data is #{data_arv[i]} "
	
 end

puts ""
puts "***************************************"
puts  "        schedualing-options       "
puts "1-FCFS 2-SJF 3-RR(1) 4-RR(3) 5-SRT    "
puts "**************************************"
puts ""
puts "enter a choice"
@a=gets.to_i
case @a
when 1
	sc=FCFS.new()
when 2
	sc=SJF.new()

when 3
	sc=RR.new()
	
when 4
	sc=SRT.new()
	
else
	puts "no idea"
end
 
	sc.semu
	sc.show

#puts $all_pr.length

while (!$all_pr.empty?)
	$all_pr.shift
	$completed.shift
end

for i in 1..@n
#puts	p[i].name
p[i]=nil
ObjectSpace.garbage_collect
end




#ObjectSpace.garbage_collect
@zz+=1

end

