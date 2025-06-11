-- 1. Find if there are any duplicate records in the employees table.  
SELECT employee_id
FROM HR.EMPLOYEES
GROUP BY employee_id
HAVING COUNT(*)>1;

-- 2. Count the total number of employees for each job title. 
SELECT job_id, COUNT(employee_id) AS employee_count
FROM HR.EMPLOYEES
GROUP BY job_id;

-- 3. Identify which departments are operating without a designated manager.  
SELECT department_name 
FROM HR.DEPARTMENTS
WHERE manager_id IS NULL
ORDER BY 1;

-- 4. Determine which job titles have the highest and lowest minimum salaries.  
(SELECT job_title, min_salary
FROM HR.JOBS 
ORDER BY min_salary DESC
FETCH FIRST 1 ROW ONLY)
union all
(SELECT job_title, min_salary
FROM HR.JOBS 
ORDER BY min_salary ASC
FETCH FIRST 1 ROW ONLY);

-- 5. Identify the number of reportees each manager has.  
WITH cte AS (SELECT manager_id,COUNT(manager_id) AS reportees_count
FROM HR.EMPLOYEES
WHERE manager_id IS NOT NULL
GROUP BY manager_id)
SELECT cte.manager_id,e.first_name || ' ' || e.last_name as "Manager_Name", cte.reportees_count
FROM cte JOIN HR.EMPLOYEES e 
ON cte.manager_id=e.employee_id;

-- 6. Identify the employee with the highest salary in each department.  
WITH cte AS (SELECT employee_id,department_id,salary
FROM (SELECT employee_id,department_id,salary, 
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS ranks
        FROM HR.EMPLOYEES)a 
WHERE ranks=1)
SELECT d.department_name,e.first_name || ' ' || e.last_name AS "Emp_Name",cte.salary
FROM cte JOIN HR.EMPLOYEES e ON cte.employee_id=e.employee_id
JOIN HR.DEPARTMENTS d ON cte.department_id=d.department_id
ORDER BY cte.salary DESC;

-- 7. Calculate the length of service for each employee expressed in years (rounded to the largest integer).
SELECT first_name || ' ' || last_name AS "Emp_Name",
    FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE),hire_date)/12) AS "Length of Service"
FROM HR.EMPLOYEES;