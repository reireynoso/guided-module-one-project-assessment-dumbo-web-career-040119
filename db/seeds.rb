Student.destroy_all
Teacher.destroy_all
Course.destroy_all

#Joint model instances gets created last

rei = Student.create(name: "Rei", age: 14)

graham = Teacher.create(first_name: "Graham", last_name: "Troyer-Joy")
ryan = Teacher.create(first_name: "Ryan", last_name: "Ghaida")
jane = Teacher.create(first_name: "Jane", last_name: "Costa")
reynoso = Teacher.create(first_name: "R", last_name: "Reynoso")
jiraiya = Teacher.create(first_name: "Jiraiya", last_name: "Sensei")
kakashi = Teacher.create(first_name: "Kakashi", last_name: "Hatake")
yoda = Teacher.create(first_name: "Yoda", last_name: "Minch")
einstein = Teacher.create(first_name: "Albert", last_name: "Einstein")


# coding = Course.create(teacher_id: graham.id, name: "Coding")
# muay_thai = Course.create(teacher_id: ryan.id, name: "Muay Thai")
# finding_cohort_name = Course.create(teacher_id: jane.id, name: "Finding Cohort Name")

Course.create(teacher_id: graham.id, name: "Coding")
Course.create(teacher_id: ryan.id, name: "Muay Thai")
Course.create(teacher_id: jane.id, name: "Finding Cohort Name")
Course.create(teacher_id: reynoso.id, name: "Mathematics")
Course.create(teacher_id: jiraiya.id, name: "Ninja Arts")
Course.create(teacher_id: kakashi.id, name: "Perversion Arts")
Course.create(teacher_id: yoda.id, name: "Feeling the Force")
Course.create(teacher_id: einstein.id, name: "Extreme Physics")


