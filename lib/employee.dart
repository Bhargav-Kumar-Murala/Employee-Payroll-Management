class Employee {
  final num id;
  final String name;
  final String dept;
  final String dos;
  final double salm;

  Employee(
    this.id,
    this.name,
    this.dept,
    this.dos,
    this.salm,
  );
  factory Employee.fromMap(Map<String, dynamic> data) {
    return Employee(
      data['id'],
      data['name'],
      data['dept'],
      data['dos'],
      data['salm'],
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "dept": dept,
        "dos": dos,
        "salm": salm,
      };
}
