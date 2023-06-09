-- ESTABLISH SCHEMA --
drop table if exists titles;
create table titles (
	title_id varchar(5) primary key,
	title varchar(31) not null
);

drop table if exists employees;
create table employees (
	emp_no int primary key,
	emp_title_id varchar(5) references titles(title_id) not null,
	birth_date varchar(10) not null,
	first_name varchar(63) not null,
	last_name varchar(63) not null,
	sex varchar(1) not null,
	hire_date varchar(10) not null
);

drop table if exists salaries;
create table salaries (
	emp_no int primary key not null,
	salary int not null
);

drop table if exists departments;
create table departments (
	dept_no varchar(10) primary key,
	dept_name varchar(31) not null
);

drop table if exists dept_emp;
create table dept_emp (
	emp_no int references employees(emp_no) not null,
	dept_no varchar(10) references departments(dept_no) not null
);

drop table if exists dept_manager;
create table dept_manager (
	dept_no varchar(10) references departments(dept_no) not null,
	emp_no int not null
);


---- DATA ANALYSIS ----

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
select employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
from employees
inner join salaries on
employees.emp_no = salaries.emp_no;


-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
select employees.first_name, employees.last_name, employees.hire_date
from employees
where right(hire_date, 4) = '1986';


-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
alter table employees
	add column manager_full_name varchar;

update employees set manager_full_name = concat(first_name,' ',last_name);

select employees.manager_full_name, dept_manager.dept_no, departments.dept_name, employees.emp_no, employees.last_name, employees.first_name
from dept_manager
inner join employees on
dept_manager.emp_no = employees.emp_no
inner join departments on
dept_manager.dept_no = departments.dept_no;


-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
select dept_emp.dept_no, employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
from employees
inner join dept_emp on
employees.emp_no = dept_emp.emp_no
inner join departments on
departments.dept_no = dept_emp.dept_no;


-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select employees.first_name, employees.last_name, employees.sex
from employees
where employees.first_name = 'Hercules'
	and left(employees.last_name, 1) = 'B';


-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
select employees.emp_no, employees.last_name, employees.first_name
from employees
inner join dept_emp on
employees.emp_no = dept_emp.emp_no
inner join departments on
departments.dept_no = dept_emp.dept_no
where departments.dept_name = 'Sales';


-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
select employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
from employees
inner join dept_emp on
employees.emp_no = dept_emp.emp_no
inner join departments on
departments.dept_no = dept_emp.dept_no
where departments.dept_name = 'Sales'
	or departments.dept_name = 'Development';


-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
select last_name, count(last_name)
from employees
group by last_name
order by count(last_name) desc;

