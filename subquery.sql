-- Whose employee job is same as the job of 'Ellen' and who are earning Salary more than Ellen salary?

SELECT * FROM employees WHERE job_id = 
    (SELECT job_id FROM employees WHERE first_name = 'Ellen')
    AND salary > (
        SELECT salary FROM EMPLOYEES WHERE first_name = 'Ellen'
    );
    
-- DISPLAY EMPLOYEES WHO SALARY IS MORE THAN AvERage SAL OF DEPARTMNET

-- Display senior employee among all the employees;

SELECT MIN(hire_date) FROM employees;

SELECT * FROM employees WHERE hire_date = (SELECT MIN(hire_date) FROM employees);

-- second highrst salary

SELECT MAX(salary) FROM employees;

SELECT MAX(salary) FROM employees WHERE salary < (SELECT MAX(salary) FROM employees);

-- second highest salaried employee

SELECT * FROM employees WHERE salary = (
    SELECT MAX(salary) FROM employees WHERE salary < (
        SELECT MAX(salary) FROM employees
    )
);

-- Sum of salary of jobs if the sum of salary of jobs are more than the sum of salary of the job is 'Clerk'?

SELECT SUM(salary) FROM employees WHERE job_id LIKE '%CLERK%';

SELECT job_id, SUM(salary)
FROM employees GROUP BY job_id HAVING SUM(salary) >
(SELECT SUM(salary) FROM employees WHERE job_id LIKE '%CLERK%');

-- MULTY ROW SUBQUERY

SELECT * FROM employees WHERE salary = (
    SELECT MAX(salary) FROM employees GROUP BY department_id
);

--ORA-01427: single-row subquery returns more than one row
/*
    IN
    NOT IN
    >ANY
    <ANY
    >ALL
    <ALL
*/    

-- whose employee job is the same as the job of 'James'?

SELECT * FROM employees WHERE job_id = (
    SELECT job_id FROM employees WHERE first_name='James'
);
--ORA-01427: single-row subquery returns more than one row

SELECT * FROM employees WHERE job_id IN (
    SELECT job_id FROM employees WHERE first_name='James'
);

SELECT * FROM employees WHERE salary IN (
    SELECT MAX(salary) FROM employees GROUP BY department_id
) ORDER BY department_id;

-- 3 Multi column sub query

SELECT * FROM employees WHERE (department_id, salary) IN (
    SELECT department_id, MAX(salary) FROM employees
    GROUP BY department_id
) ORDER BY department_id;

-------------------------

SELECT * FROM employees WHERE department_id > ANY
(
    SELECT department_id FROM departments WHERE department_name IN
    ('Purchasing', 'IT','Executive')
) ORDER BY department_id;

SELECT * FROM employees WHERE department_id < ANY (30,60,90) ORDER BY department_id;

SELECT * FROM employees WHERE department_id < ALL (30, 60, 90) ORDER BY department_id;

SELECT * FROM employees WHERE department_id > ALL (30, 60, 90) ORDER BY department_id;

------------------------

-- select the departments where no employees are working

SELECT * FROM departments WHERE department_id NOT IN (
    SELECT DISTINCT department_id FROM employees WHERE department_id IS NOT NULL
);

----------------------------------------

-- CO - RELEATED SUB QUERY
/*
    For every one record it execute the inner query
    
    Find employees having atleast one person reporting under him
    
    non co-related sub query:
*/

SELECT * FROM employees WHERE employee_id IN (
    SELECT manager_id FROM employees GROUP BY manager_id
);

SELECT * FROM employees a WHERE 1 <= (
    SELECT COUNT(*) FROM employees b
    WHERE b.manager_id = a.employee_id
);
/*
    The Oracle EXISTS operator is a Boolean operator that returns either true or false. The EXISTS operator is
    often used with a subquery to test for the existence of rows:
    
    An EXISTS condition tests for existence of rows in a subquery. If at least one row returns, it will evaluate
    as TRUE.
    
    The EXISTS operator returns true if the subquery returns any rows, otherwise, it returns false. In
    addition, the EXISTS operator terminates the processing of the subquery once the subquery returns the
    first row.
    
    The EXISTS subquery is used when we want to display all rows where we have a matching column in both
    tables
    
    The IN clause is faster than EXISTS when the subquery results is very small.
    
    The IN clause can't compare anything with NULL values, but the EXISTS clause can compare everything
    with NULLs
    
    This returns the employees (in the EMP table) that are managers. It checks for their employee number as
    a manager (mgr column) and returns them if they are found at least once.
*/

-- SELECT * FROM table_name WHERE EXISTS(subquery);

SELECT * FROM employees e1
    WHERE EXISTS (
        SELECT NULL FROM employees e2
        WHERE e2.manager_id = e1.employee_id
);
