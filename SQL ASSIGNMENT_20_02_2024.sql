-- 1. Consolidate Datasets:
-- Combine the four datasets (Employee Details, Project Assignments, Attendance Records, and Training Programs) into a centralized MySQL database.
select * from employee_details join project_assignments join attendance_records join training_programs;

-- 2. Add Mapping for Training Programs:
-- Use logical mapping to add employee_id to the Training Programs dataset by matching department_id and employee_name from the Employee Details dataset.
select * from training_programs, employee_id from tech_sphere.employee_id join tech_sphere.training_programs on training_program.employee_id=employee_detail.employee_id;

-- 3. Schema Design:
-- Create a relational schema with the following tables:
  -- Employee_Details: Contains core employee information.
  -- Project_Assignments: Tracks projects and employee contributions.
  -- Attendance_Records: Logs employee attendance data.
  -- Training_Programs: Details training sessions and feedback scores.
  -- Analysis Tasks
-- 1. Employee Productivity Analysis:
-- Identify employees with the highest total hours worked and least absenteeism.
select employeename, total_hours from attendance_records order by total_hours desc;
-- 2. Departmental Training Impact:
-- Analyze how training programs improve departmental performance.
select program_name,count(program_name) from training_programs group by program_name;
-- 3. Project Budget Efficiency:
-- Evaluate the efficiency of project budgets by calculating costs per hour worked.
  select project_assignments.project_id, project_assignments.project_name, sum(project_assignments.budget) as total_budget, sum(hours_worked) as total_hours, sum(project_assignments.budget)/ sum(hours_worked) as cost_per_hours from project_assignments group by project_id, project_name order by cost_per_hours asc;
-- 4. Attendance Consistency:
-- Measure attendance trends and identify departments with significant deviations.
SELECT 
  ar.employeeid,
  AVG(ar.total_hours) AS avg_daily_attendance,
  SUM(CASE WHEN ar.total_hours = 0 THEN 1 ELSE 0 END) / COUNT(*) AS absenteeism_rate,
  SUM(CASE WHEN ar.check_in_time > '09:00:00' THEN 1 ELSE 0 END) / COUNT(*) AS tardiness_rate
FROM 
  Attendance_Records ar
GROUP BY 
  ar.employeeid
ORDER BY 
  avg_daily_attendance DESC;
  
  -- 5. Training and Project Success Correlation:
-- Link training technologies with project milestones to assess the real-world impact of training.
SELECT employee_details.employeeid, employee_details.employeename,
training_programs.program_name AS training_program,
training_programs.technologies_covered,
project_assignments.project_name,
project_assignments.technologies_used,
project_assignments.milestones_achieved
FROM training_programs
JOIN project_assignments ON training_programs.employeeid = project_assignments.employeeid
JOIN employee_details ON employee_details.employeeid = training_programs.employeeid
ORDER BY project_assignments.milestones_achieved DESC;

-- 6. High-Impact Employees:
-- Identify employees who significantly contribute to high-budget projects while maintaining excellent performance scores.
select employee_details.employeeid, employee_details.employeename, employee_details.performance_score, project_assignments.budget from employee_details join project_assignments on employee_details.employeeid=project_assignments.employeeid  where performance_score='Excellent';

-- 7. Cross-Analysis of Training and Project Success
-- Identify employees who have undergone training in specific technologies and contributed to high-performing projects using those technologies.
select training_programs.employeeid,training_programs.employeename,training_programs.completion_status,program_id, training_programs.program_name,employee_details.performance_score from training_programs join employee_details on training_programs.employeeid=employee_details.employeeid where training_programs.completion_status='Completed';