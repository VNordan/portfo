class VacanciesController < ApplicationController
before_action :calend, :date_list
#before_action :authenticate_user!
acts_as_token_authentication_handler_for User
#load_and_authorize_resource

	def show
    authorize! :show, EmployeeStatsDepartments
    #render plain: @actualy_date.inspect
    #render plain: @month_list.inspect
    
  end

	def edit
    @vacancy = EmployeeStatsDepartments.where(month: params[:date]).order(:id)
    authorize! :edit, EmployeeStatsDepartments
    #render plain: @vacancy.inspect
	end

	def update
    r = 0 #промежуточный счётчик для суммы вакансий по всем отделам

		params[:from_the_form].each do |key, value|  	#перебираем полученный из формы хэш "id" => "значение поля формы"
      
	 		stro = EmployeeStatsDepartments.find(key)   #ищем в таблице строку с id
	 		stro.vacancy_count = value									#присваиваем полю в строке значение, полученное из формы.
      r += value.to_i
			stro.save
		end

    v = EmployeeStatsMonths.find_by month: params[:tek_date] #выбираем по текущей дате месяц из таблицы employee_stats_months
    v.vacancy_count = r       #пишем в нужное поле общую сумму вакансий по отделам
    v.save                    #сохраняем новое значение

    temp_date = params[:tek_date].split('-')

    redirect_to action: 'show', mon_select: {year: temp_date[0], month: temp_date[1]}

	end

	private

  def date_list #сдесь мы формируем два списка: годы и месяцы, присутствующих в базе дат, из которых потом делаем форму выбора даты.

    all_date = EmployeeStatsDepartments.select("month").distinct.order(:month)
    
    years = []
    month = []
    all_date.each do |date|
      years.push date.month.strftime('%Y')
      month.push date.month.strftime('%m')
    end
    @year_list = years.uniq
    @month_list = month.uniq
  end
 
  def calend

    #puts params.inspect

    if params[:tek_date]
      @tek_date = params[:tek_date]

    elsif params[:mon_select]
      @tek_date = params[:mon_select][:year]+'-'+params[:mon_select][:month]+'-15'    #строим текущую дату на середину месяца
    
    else
      @tek_date = Date.today.strftime("%Y-%m")+'-15'
    end

      @vacancy = EmployeeStatsDepartments.where(month: @tek_date).order(:id)

  end

end
