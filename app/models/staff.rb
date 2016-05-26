class Staff

  @hiredCount
  @firedCount
  @underStaffing
  @turnover
  @bossTaxes
  @bossBonuses
  @bossSalary
  @bossAverageSalary
  @bossCount
  @departments
  @departmentsGroups
  @taxes
  @bonuses
  @salary
  @averageSalary
  @employeeCount
  @vacancyCount
  @departmentHead
  @manageEmployeeCount
  @productionEmployeeCount



  def initialize
    self.departmentsGroups
    self.departments
    self.taxes
    self.bonuses
    self.salary
    self.averageSalary
    self.employeeCount
    self.vacancyCount
    self.departmentHead
    self.hiredCount
    self.firedCount
    self.underStaffing
    self.turnover
    self.bossTaxes
    self.bossBonuses
    self.bossSalary
    self.bossAverageSalary
    self.bossCount
    self.manageEmployeeCount
    self.productionEmployeeCount

  end

  def self.set_valid_date date
    (date - date.at_beginning_of_month.day).to_time.to_i
  end

  def departmentsGroups
    @departmentsGroups = [{id:1, name: "Первый зам. генерального директора по проектированию и строительству", order_index: 1},
     {id:2, name: "Первый зам. генерального директора по общим вопросам", order_index: 2},
     {id:3, name: "Первый зам. генерального директора по экономике и финансам", order_index: 3},
     {id:4, name: "Pам. генерального директора по производству", order_index: 4}]
    @departmentsGroups
  end

  def departments
    @departments = EmployeeStatsDepartments.select('dep_name as name,department_group_id' ).distinct.each_with_index do |d, i|
      d.id = i+1
    end
    @departments
  end

  def taxes
    @taxes = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @taxes.push ({date: Staff.set_valid_date(d.month), count: d.tax, department_id: dep_id+1})
    end
  end

  def bonuses
    @bonuses = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @bonuses.push ({date: Staff.set_valid_date(d.month), count: d.bonus, department_id: dep_id+1})
    end
  end

  def salary
    @salary = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @salary.push ({date: Staff.set_valid_date(d.month), count: d.salary, department_id: dep_id+1})
    end
  end

  def averageSalary
    @averageSalary = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @averageSalary.push ({date: Staff.set_valid_date(d.month), count: d.avg_salary, department_id: dep_id+1})
    end
  end

  def employeeCount
    @employeeCount = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @employeeCount.push ({date: Staff.set_valid_date(d.month), count: d.employee_count, department_id: dep_id+1, full: d.employee_count-2, half:2, quater: 4, other: 1})
    end
  end

  def vacancyCount
    @vacancyCount = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @vacancyCount.push ({date: Staff.set_valid_date(d.month), count: d.vacancy_count, department_id: dep_id+1, full: 1, half:1, quater: 2, other: 1})
    end
  end

  def departmentHead
    @departmentHead = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.month..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @departmentHead.push ({date: Staff.set_valid_date(d.month), name: d.manager, department_id: dep_id+1})
    end
  end

  # def hiredCount
  #   @hiredCount = Array.new
  #   EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
  #     @hiredCount.push ({date: Staff.set_valid_date(s.month), count:s.employee_adds, full: 1, half:1, quater: 2, other: 1})
  #   end
  #   @hiredCount
  # end
  #
  # def firedCount
  #   @firedCount = Array.new
  #   EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
  #     @firedCount.push ({date: Staff.set_valid_date(s.month), count:s.employee_dismiss, full: 1, half:1, quater: 2, other: 1})
  #   end
  #   @firedCount
  # end

  def hiredCount
    @hiredCount = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @hiredCount.push ({date: Staff.set_valid_date(d.month), department_id: dep_id+1, count: 6, full: 3, half:4, quater: 2, other: 1})
    end
    @hiredCount
  end

  def firedCount
    @firedCount = Array.new
    EmployeeStatsDepartments.where(month: Date.current-1.year..Date.current).each do |d|
      dep_id = @departments.find_index {|item| item.name == d.dep_name}
      @firedCount.push ({date: Staff.set_valid_date(d.month),department_id: dep_id+1,  count:5, full: 2, half:3, quater: 1, other: 0})
    end
    @firedCount
  end

  def underStaffing
    @underStaffing = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @underStaffing.push ({date: Staff.set_valid_date(s.month), count:s.k_complect*100})
    end
    @underStaffing
  end

  def turnover
    @turnover = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @turnover.push ({date: Staff.set_valid_date(s.month), count:s.k_dismiss*100})
    end
    @turnover
  end

  def bossTaxes
    @bossTaxes = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @bossTaxes.push ({date: Staff.set_valid_date(s.month), count:s.tax_manage})
    end
    @bossTaxes
  end

  def bossBonuses
    @bossBonuses = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @bossBonuses.push ({date: Staff.set_valid_date(s.month), count:s.bonus_manage})
    end
    @bossBonuses
  end

  def bossSalary
    @bossSalary = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @bossSalary.push ({date: Staff.set_valid_date(s.month), count:s.salary_manage})
    end
    @bossSalary
  end

  def bossAverageSalary
    @bossAverageSalary = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @bossAverageSalary.push ({date: Staff.set_valid_date(s.month), count:s.avg_salary_manage})
    end
    @bossAverageSalary
  end

  def bossCount
    @bossCount = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @bossCount.push ({date: Staff.set_valid_date(s.month), count:s.AUP_count})
    end
    @bossCount
  end

  def manageEmployeeCount
    @manageEmployeeCount = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @manageEmployeeCount.push ({date: Staff.set_valid_date(s.month), count:s.employee_manage_count})
    end
    @manageEmployeeCount
  end

  def productionEmployeeCount
    @productionEmployeeCount = Array.new
    EmployeeStatsMonths.where(month: Date.current-1.year..Date.current).each do |s|
      @productionEmployeeCount.push ({date: Staff.set_valid_date(s.month), count:s.employee_production_count})
    end
    @productionEmployeeCount
  end
end