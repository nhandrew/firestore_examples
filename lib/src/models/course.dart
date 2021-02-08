class Course {
  String courseId;
  final String name;
  final String instructor;
  final int capacity;

  Course({this.capacity,this.name,this.instructor,this.courseId});

  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'instructor':instructor,
      'capacity':capacity,
      'course_id':courseId,
    };
  }

  factory Course.fromJson(Map<String,dynamic> json){
    return Course(
      name: json['name'],
      capacity: json['capacity'],
      instructor: json ['instructor'],
      courseId: json ['course_id']
    );
  }
}