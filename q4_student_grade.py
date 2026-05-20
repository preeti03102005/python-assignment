student_name = input("Enter student name: ")
student_class = input("Enter class: ")

m1 = int(input("Enter marks of subject 1: "))
m2 = int(input("Enter marks of subject 2: "))
m3 = int(input("Enter marks of subject 3: "))
m4 = int(input("Enter marks of subject 4: "))
m5 = int(input("Enter marks of subject 5: "))

total = m1 + m2 + m3 + m4 + m5
percentage = (total / 500) * 100

if percentage >= 60:
    grade = "A"

elif percentage >= 50 and percentage < 60:
    grade = "B"

elif percentage >= 40 and percentage < 50:
    grade = "C"

elif percentage >= 33 and percentage < 40:
    grade = "D"

else:
    grade = "Fail"

print("Student Name:", student_name)
print("Class:", student_class)
print("Percentage:", percentage)
print("Grade:", grade)