#######################
##Process Scheduling
##
##Torchi Rokaya 
#######################

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
	
	def semu(qun)

		for p in $all_pr
			$raw_process<<p
			#puts "#{p.name}"
		end 

		$raw_process.sort! {|a,b| a.at <=> b.at}

	while $completed.length < $all_pr.length do
 			
 			$time += qun
 			@time_beg = $time-qun
 			@count=0
				while ( $raw_process.length>0 && $time > $raw_process[0].at)	
								@a=$raw_process.shift
								$readyQ<<@a
						#		puts "#{@a.name}"
						end
					

					if (!$readyQ.empty?)
						$current_process=$readyQ.shift
						$current_process.st=$current_process.st-qun
					
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

puts "enter number in multiple of 5"
puts "enter number of process"
@n=gets.to_i
 
case @n

## these data are randomly generated by other ruby program as an output..
when 5
Prcs.new(3,6 ,'p1') 
Prcs.new(2,9 ,'p2') 
Prcs.new(5,6 ,'p3') 
Prcs.new(7,13 ,'p4') 
Prcs.new(9,12 ,'p5')

when 10
Prcs.new(2,9 ,'p1')
Prcs.new(7,3 ,'p2')
Prcs.new(1,14 ,'p3')
Prcs.new(6,2 ,'p4')
Prcs.new(0,12 ,'p5')
Prcs.new(0,11 ,'p6')
Prcs.new(8,8 ,'p7')
Prcs.new(6,1 ,'p8')
Prcs.new(3,6 ,'p9')
Prcs.new(7,11 ,'p10')


when 15
Prcs.new(4,5 ,'p1')
Prcs.new(1,12 ,'p2')
Prcs.new(8,7 ,'p3')
Prcs.new(8,12 ,'p4')
Prcs.new(8,11 ,'p5')
Prcs.new(4,9 ,'p6')
Prcs.new(9,11 ,'p7')
Prcs.new(6,6 ,'p8')
Prcs.new(8,4 ,'p9')
Prcs.new(0,15 ,'p10')
Prcs.new(8,10 ,'p11')
Prcs.new(8,1 ,'p12')
Prcs.new(8,14 ,'p13')
Prcs.new(4,9 ,'p14')
Prcs.new(8,4 ,'p15')


when 20
Prcs.new(3,7 ,'p1')
Prcs.new(1,7 ,'p2')
Prcs.new(5,3 ,'p3')
Prcs.new(4,5 ,'p4')
Prcs.new(9,10 ,'p5')
Prcs.new(3,9 ,'p6')
Prcs.new(7,8 ,'p7')
Prcs.new(7,13 ,'p8')
Prcs.new(7,12 ,'p9')
Prcs.new(6,11 ,'p10')
Prcs.new(4,15 ,'p11')
Prcs.new(6,14 ,'p12')
Prcs.new(9,5 ,'p13')
Prcs.new(4,12 ,'p14')
Prcs.new(9,13 ,'p15')
Prcs.new(9,14 ,'p16')
Prcs.new(4,3 ,'p17')
Prcs.new(8,2 ,'p18')
Prcs.new(3,11 ,'p19')
Prcs.new(2,6 ,'p20')


when 25
Prcs.new(0,3 ,'p1')
Prcs.new(1,11 ,'p2')
Prcs.new(2,1 ,'p3')
Prcs.new(6,12 ,'p4')
Prcs.new(0,9 ,'p5')
Prcs.new(8,4 ,'p6')
Prcs.new(3,11 ,'p7')
Prcs.new(8,13 ,'p8')
Prcs.new(9,13 ,'p9')
Prcs.new(3,1 ,'p10')
Prcs.new(6,7 ,'p11')
Prcs.new(5,14 ,'p12')
Prcs.new(8,14 ,'p13')
Prcs.new(0,11 ,'p14')
Prcs.new(0,10 ,'p15')
Prcs.new(8,3 ,'p16')
Prcs.new(6,6 ,'p17')
Prcs.new(2,8 ,'p18')
Prcs.new(2,9 ,'p19')
Prcs.new(6,8 ,'p20')
Prcs.new(2,13 ,'p21')
Prcs.new(8,10 ,'p22')
Prcs.new(8,3 ,'p23')
Prcs.new(2,11 ,'p24')
Prcs.new(0,1 ,'p25')
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
				sc.semu()
		when 2
			sc=SJF.new()
			sc.semu()

		when 3
			sc=RR.new()
				sc.semu(1)
			
		when 4
			sc=RR.new()
				sc.semu(3)
		when 5
			sc=SRT.new()
			sc.semu()
			
			
		else
	puts "invalide choice"
end
 

	sc.show
