require_relative('../models/lesson.rb')
require_relative('../models/member.rb')
require_relative('../models/member_lesson.rb')
require_relative('../models/physio.rb')
require_relative('../models/patient.rb')
require_relative('../models/condition.rb')

require('pry')

Condition.delete_all()
Physio.delete_all()
Patient.delete_all()
MemberLesson.delete_all()
Member.delete_all()
Lesson.delete_all()

member1 = Member.new({'name' => 'Alfred Addington', 'premium' => true})
member1.save()
member2 = Member.new({'name' => 'Bob Buttons', 'premium' => false})
member2.save()
member3 = Member.new({'name' => 'Charles Chase', 'premium' => true})
member3.save()
member4 = Member.new({'name' => 'Derek Drew', 'premium' => false})
member4.save()


lesson1 = Lesson.new({'course' => 'Yoga, Friday evening', 'capacity' => 12, 'peak' => true})
lesson1.save()
lesson2 = Lesson.new({'course' => 'Yoga, Wednesday morning', 'capacity' => 10, 'peak' => false})
lesson2.save()
lesson3 = Lesson.new({'course' => 'Cardio, Saturday afternoon', 'capacity' => 15, 'peak' => true})
lesson3.save()
lesson4 = Lesson.new({'course' => 'Cardio, Monday morning', 'capacity' => 12, 'peak' => false})
lesson4.save()

member_lesson1 = MemberLesson.new({'member_id' => member1.id, 'lesson_id' => lesson1.id})
member_lesson1.save()
member_lesson2 = MemberLesson.new({'member_id' => member1.id, 'lesson_id' => lesson3.id})
member_lesson2.save()
member_lesson3 = MemberLesson.new({'member_id' => member2.id, 'lesson_id' => lesson2.id})
member_lesson3.save()
member_lesson4 = MemberLesson.new({'member_id' => member3.id, 'lesson_id' => lesson1.id})
member_lesson4.save()

patient1 = Patient.new({'patient_name' => 'Charles Chase', 'member_id' => member3.id})
patient1.save()
patient2 = Patient.new({'patient_name' => 'Edgar Ebert'})
patient2.save()

physio1 = Physio.new({'physio_name' => 'Zach Zizek'})
physio1.save()
physio2 = Physio.new({'physio_name' => 'Yacob Yearling'})
physio2.save()

condition1 = Condition.new({'patient_id' => patient1.id, 'physio_id' => physio1.id, 'type' => 'Shoulder Pain', 'diagnosed' => '2018-12-05', 'resolved' => false, 'notes' => 'very distracting'})
condition1.save()
condition2 = Condition.new({'patient_id' => patient2.id, 'physio_id' => physio2.id, 'type' => 'Fractured Pelvis', 'diagnosed' => '2018-05-12', 'resolved' => true, 'resolved_date' => '2018-08-17', 'notes' => 'snu-snu incident'})
condition2.save()
condition3 = patient1.add_condition(physio1, 'Lower Back Pain')
condition3.save()

binding.pry

nil
