from pyspark import SparkConf, SparkContext
import os

def main():

    conf = SparkConf() \
        .setAppName("EmployeeRDDProcessing") \
        .setMaster("local[*]")

    sc = SparkContext(conf=conf)

    input_file = "/app/data/employee.csv"

    lines = sc.textFile(input_file)

    header = lines.first()

    employee_rdd = (
        lines
        .filter(lambda x: x != header)
        .map(lambda x: x.split(","))
        .map(lambda x: {
            "id": int(x[0]),
            "name": x[1],
            "department": x[2],
            "salary": int(x[3])
        })
    )

    print("\n===================================")
    print("Employees Sorted By Salary DESC")
    print("===================================")

    sorted_employees = employee_rdd.sortBy(
        lambda emp: emp["salary"],
        ascending=False
    )

    for emp in sorted_employees.collect():
        print(emp)

    print("\n===================================")
    print("Department Wise Salary Totals")
    print("===================================")

    department_totals = (
        employee_rdd
        .map(lambda emp: (emp["department"], emp["salary"]))
        .reduceByKey(lambda a, b: a + b)
    )

    for dept, total in department_totals.collect():
        print(f"{dept}: {total}")

    print("\n===================================")
    print("Top 3 Highest Paid Employees")
    print("===================================")

    top3 = sorted_employees.take(3)

    output_rdd = sc.parallelize([
        f"{emp['id']},{emp['name']},{emp['department']},{emp['salary']}"
        for emp in top3
    ])

    output_dir = "/app/output/top3_employees"

    if os.path.exists(output_dir):
        import shutil

        if os.path.isdir(output_dir):
            shutil.rmtree(output_dir)
        else:
            os.remove(output_dir)

    output_rdd.coalesce(1).saveAsTextFile(output_dir)

    for emp in top3:
        print(emp)

    sc.stop()


if __name__ == "__main__":
    main()