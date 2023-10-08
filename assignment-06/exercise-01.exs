# Define a module and struct Employee, and add struct fields:
# - first name
# - last name
# - id number
# - salary
# - job, which is one of the {:none, :coder, :designer, :manager, :ceo }

# id number has a default value that is previous id + 1
# salary has a default value 0
# job has a default value of :none

# Implement functions Employee.promote and Employee.demote which updates the job accordingly.
# - job :none salary is set to 0
# - each job above :none gets 2000 more salary than previous

defmodule Employee do
  defstruct [:first_name, :last_name, :id_number, salary: 0, job: :none]

  def new(first_name, last_name, previous_id) do
    %Employee{
      first_name: first_name,
      last_name: last_name,
      id_number: previous_id + 1
    }
  end

  def display(employee) do
    IO.puts("Employee #{employee.first_name} #{employee.last_name} (id: #{employee.id_number})")
    IO.puts("  job: #{employee.job}")
    IO.puts("  salary: #{employee.salary}")
    employee
  end

  def promote(employee) do
    case employee.job do
      :none -> %Employee{employee | job: :coder, salary: 2000}
      :coder -> %Employee{employee | job: :designer, salary: 4000}
      :designer -> %Employee{employee | job: :manager, salary: 6000}
      :manager -> %Employee{employee | job: :ceo, salary: 8000}
      :ceo -> employee
    end
  end

  def demote(employee) do
    case employee.job do
      :none -> employee
      :coder -> %Employee{employee | job: :none, salary: 0}
      :designer -> %Employee{employee | job: :coder, salary: 2000}
      :manager -> %Employee{employee | job: :designer, salary: 4000}
      :ceo -> %Employee{employee | job: :manager, salary: 6000}
    end
  end
end

employee_1 = Employee.new("John", "Doe", 0)
employee_2 = Employee.new("Jane", "Doe", employee_1.id_number)
employee_3 = Employee.new("John", "Smith", employee_2.id_number)
employee_4 = Employee.new("Jane", "Smith", employee_3.id_number)
employee_5 = Employee.new("John", "Johnson", employee_4.id_number)

employee_1 |> Employee.promote() |> Employee.display()
employee_2 |> Employee.promote() |> Employee.promote() |> Employee.display()
employee_3 |> Employee.promote() |> Employee.promote() |> Employee.promote() |> Employee.display()

employee_4
|> Employee.promote()
|> Employee.promote()
|> Employee.promote()
|> Employee.promote()
|> Employee.display()

employee_5
|> Employee.promote()
|> Employee.promote()
|> Employee.promote()
|> Employee.promote()
|> Employee.promote()
|> Employee.display()
|> Employee.demote()
|> Employee.display()
|> Employee.demote()
|> Employee.display()
|> Employee.demote()
|> Employee.display()
|> Employee.demote()
|> Employee.display()
|> Employee.demote()
|> Employee.display()
