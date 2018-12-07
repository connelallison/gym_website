require_relative('../models/lesson.rb')
require_relative('../models/member.rb')
require_relative('../models/member_lesson.rb')

require('pry')

MemberLesson.delete_all()
Member.delete_all()
Lesson.delete_all()

member1 = Member.new({'name' => 'Alfred', 'premium' => true})
member1.save()
member2 = Member.new({'name' => 'Bob', 'premium' => false})
member2.save()
member3 = Member.new({'name' => 'Charles', 'premium' => true})
member3.save()
member4 = Member.new({'name' => 'Derek', 'premium' => false})
member4.save()


lesson1 = Lesson.new({'name' => 'Yoga, Friday evening', 'capacity' => 12, 'peak' => true})
lesson1.save()
lesson2 = Lesson.new({'name' => 'Yoga, Wednesday morning', 'capacity' => 10, 'peak' => false})
lesson2.save()
lesson3 = Lesson.new({'name' => 'Cardio, Saturday afternoon', 'capacity' => 15, 'peak' => true})
lesson3.save()
lesson4 = Lesson.new({'name' => 'Cardio, Monday morning', 'capacity' => 12, 'peak' => false})
lesson4.save()

member_lesson1 = MemberLesson.new({'member_id' => member1.id, 'lesson_id' => lesson1.id})
member_lesson2 = MemberLesson.new({'member_id' => member1.id, 'lesson_id' => lesson3.id})
member_lesson3 = MemberLesson.new({'member_id' => member2.id, 'lesson_id' => lesson2.id})
member_lesson4 = MemberLesson.new({'member_id' => member3.id, 'lesson_id' => lesson1.id})

binding.pry

nil
