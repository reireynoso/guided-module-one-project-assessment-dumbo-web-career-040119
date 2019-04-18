class CommandLineInterface
    def run
        prompt = TTY::Prompt.new 
        welcome = prompt.select("Welcome to Bootleg Registrar") do |menu|
            menu.choice 'SignUp' 
            menu.choice 'Login'
            menu.choice 'Change Course Name'
            menu.choice 'Exit'
        end

        if welcome == 'Login'
            login_menu
        elsif welcome == 'SignUp'
            sign_in
        elsif welcome == 'Change Course Name'
            update_course_name
        else
            puts "Goodbye"
        end
    end

    def update_course_name
        #teacher name asks
        #matches teacher with course
        #change course name
        #update
        prompt = TTY::Prompt.new  
        first_name = prompt.ask("What is your first name?")
        last_name = prompt.ask("What is your last name?")
        # puts "First Name?"
        # input1 = gets.chomp
        # puts "Last Name?"
        # input2 = gets.chomp
        # puts "Which course do you want to change?"
        # cls = gets.chomp
        
        #checks Teacher class for instances of teacher instance
        match = Teacher.all.find do |teacher|
            teacher.first_name == first_name && teacher.last_name == last_name
        end
        if match == nil
            puts "You're Not a Teacher in our DataBase"
            sleep 1
            run
        #binding.pry
        else
            # temp = Course.all.where(teacher_id: match.id)
            # puts temp[0].name
            teacher_courses = match.courses.map do |course|
                course.name
            end.uniq

            # puts "Courses You're Teaching"
            # puts teacher_courses
            course_to_change = prompt.select("Courses You're Teaching", teacher_courses) 

            temp = Course.all.where(teacher_id: match.id, name: course_to_change)

            #binding.pry
        # puts "Which course do you want to change?"
        # cls = gets.chomp
        #puts "What do you want to change to?"
            change = prompt.ask("What do you want to change the name to?")
        # match.courses[0].update(name = change)
            temp.update(name: change)
        #doesn't update the current console right away
            puts "Changed"
        #binding.pry
            sleep 1
            run
        end        
    end

    def login_menu
        system("clear")
        prompt = TTY::Prompt.new 
        current = prompt.ask("What's your Full Name?", required:true)
        current_inst = Student.all.find do |student|
            student.name == current
        end
        #binding.pry
        if current_inst == nil
            puts "Does not exist"
            #binding.pry
            run
        else
            list_options(current_inst)
        end
    end

    def sign_in
        system("clear")
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("Welcome! What's your Full Name?", required:true)
    
        if Student.all.map do |student|
            student.name
            end.include?(new_name)
            puts "Already In the Database"
            run
        else
            puts "Enter age"
            prompt = TTY::Prompt.new 
            new_age = prompt.ask("How old are you?", required:true) do |q|
                q.in('0-99')
            end
            new_inst = Student.create(name: new_name, age: new_age)
            list_options(new_inst)
        end
    end

    def available_courses
        unique_courses = Course.all.map do |course|
            course.name
        end.uniq
        #puts "===================================="
        unique_courses
        #puts "===================================="
    end

    def list_options(inst)
        system("clear")
        prompt = TTY::Prompt.new
        options = prompt.select("Which option would you like to do?") do |option|
            option.choice 'View Current Courses'
            option.choice 'View Teachers'
            option.choice 'Add Course'
            option.choice 'Drop Course'
            option.choice 'Exit'
        end

        if options == "View Current Courses"
            #available_courses
             #current courses array of passed student instance
            if inst.courses.length == 0 
                puts "Courses currently empty."
            else
                #binding.pry
                inst.courses.map do |courses|
                    puts courses.name
                end
                #puts unique
            end
            #binding.pry
            sleep 2
            system("clear")
            list_options(inst)
        elsif options == "View Teachers"
            #binding.pry
            if inst.courses.length == 0 
                puts "No Teachers Right Now."
            else
            #inst.teachers #current teachers array of passed student instance
            # Teacher.all.map do |teacher|
            #    #binding.pry
            #    puts "#{teacher.first_name} #{teacher.last_name}"
            # end #this return instance of all teachers
                inst.courses.map do |course|
                    puts "#{course.teacher.first_name} #{course.teacher.last_name}"
                end
            end
            sleep 2
            system("clear")
            list_options(inst)
        elsif options == "Add Course"

            prompt = TTY::Prompt.new
            #find specific course instance
            #update or shove into current student course array
            #available_courses
            #binding.pry
            #get list of available courses instance
            course_name = prompt.select("Courses", available_courses) 

            if enrolled?(inst,course_name)
                puts "===================================="
                puts "You're already enrolled!"
                puts "===================================="
                sleep 2
                list_options(inst)
            
            #binding.pry
            else
                course = Course.all.find do |cours|
                    cours.name == course_name
                end 
            #binding.pry
                inst.courses << Course.create(student_id: inst.id, teacher_id: course.teacher.id, name: course.name)
            #binding.pry
                #newCourse = Course.create(student_id: inst.id, teacher_id: course.teacher.id, name: course.name)
            # binding.pry
                #inst.courses << newCourse
                sleep 2
                system("clear")
                list_options(inst)
            end


        elsif options == "Drop Course"
            if inst.courses.length == 0 #checks out student instance length 
                puts "===================================="
                puts "No Courses to Drop!"
                puts "===================================="
                sleep 2
                list_options(inst)
            else
            # puts "Input course name to drop"
            # course_name = gets.chomp
            #binding.pry

            inst_course = inst.courses.map do |course|
                course.name
            end

            course_to_delete = prompt.select("Courses", inst_course) 
            #inst refers to the specific student instance

            #binding.pry
            #id = inst.courses.find_by(name: course_name).id
            id = inst.courses.find_by(name: course_to_delete).id
            v = inst.courses.find do |course|
                course.id == id
                #binding.pry
            end #destroys specific instance
            #binding.pry
            v.destroy
            #binding.pry
            new_inst = Student.all.find do |student|
                inst == student
            end #grabs the new record of instance from the database and passes it as a new argument
            #binding.pry
            puts "Dropped!"
            sleep 1
            list_options(new_inst)
        end
        
        elsif options == "Exit"
            puts "Goodbye"
            sleep 2
            system("clear")
        end

    end

    def enrolled?(instance, name) #goes through student instance and check for courses witb same name
        #inding.pry
        # if instance.courses.map do |course|
        #     course.name
        # end.include?(name)
        #     puts "===================================="
        #     puts "You're already enrolled!"
        #     puts "===================================="
        #     list_options(instance)
        # end

        instance.courses.map do |course|
            course.name
        end.include?(name)
    end
end