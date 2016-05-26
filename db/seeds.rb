# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#dep1 = Department.create(name: 'Управление 1', vacancy_count: 2)
#dep2 = Department.create(name: 'Отдел 1', vacancy_count: 2, chief_id: 1, parent: dep1)
#empl1 = Employee.create(FIO: 'Жуков Роман', tab_number: '23232', stavka: 1, department: dep1, post: 'начальник')
#empl2 = Employee.create(FIO: 'Фуксман Сергей', tab_number: '2324343', stavka: 1, department: dep2, post: 'разнорабочий')
#PersonalFlow.create(employee: empl2, old_department_id: 2, new_department_id: 1, operation_type: 'перевод')

#Инициализация словаря внешних инженерных систем
[
  {network_name: 'Электросети', network_alias: 'электросети'},
  {network_name: 'Теплосети', network_alias: 'теплосети'},
  {network_name: 'Водопровод', network_alias: 'водопровод'},
  {network_name: 'Канализация', network_alias: 'канализация'},
  {network_name: 'Водосток', network_alias: 'водосток'},
  {network_name: 'Слаботочные системы', network_alias: 'слаботочные системы'},
  {network_name: 'Оборудование', network_alias: 'оборудование'},
  {network_name: 'Благоустройство', network_alias: 'благоустройство'}
].each do |val|
  tmp_obj = ExternalEngeneeringNetwork.find_or_initialize_by(network_name: val[:network_name], network_alias: val[:network_alias])
  tmp_obj.save
end

#инициализация словаря типов документов

[
  {doc_type: "ГК с тех.заказчиком на ПИР"},
  {doc_type: "ГК с ген.подрядчиком"},
  {doc_type: "Технические условия на водосток"},
  {doc_type: "Акт разрешенного использования"},
  {doc_type: "Техническое задание на разработку проектной документации"},
  {doc_type: "Заключение Мосгосэкспертизы"},
  {doc_type: "Договор аренды земли"},
  {doc_type: "ПСД"},
  {doc_type: "Разрешение на ввод в эксплуатацию"},
  {doc_type: "Прочие"},
  {doc_type: "Техприсоединение"},
  {doc_type: "АГР Москомархитектура"},
  {doc_type: "Проект планировки"},
  {doc_type: "Акт технологического присоединения (электроснабжение)"},
  {doc_type: "Обоснование"},
  {doc_type: "Технологическое задание"},
  {doc_type: "Календарный план на проектирование"},
  {doc_type: "ТЗ на проектирование"},
  {doc_type: "Техническое задание на проектирование"},
  {doc_type: "Рабочая документация (стадия Р)"},
  {doc_type: "Задание на разработку проектно-сметной документации"},
  {doc_type: "Дело в МГЭ"},
  {doc_type: "Распорядительный документ"},
  {doc_type: "Акт передачи площадки"},
  {doc_type: "ГК с тех.заказчиком"},
  {doc_type: "Свидетельство об утверждении АГР"},
  {doc_type: "ГПЗУ / ПП"},
  {doc_type: "Утверждение проектной документации"},
  {doc_type: "Разрешение на строительство"},
  {doc_type: "Сводный сметный расчет по базовым ценам"},
  {doc_type: "Технические условия на канализацию"},
  {doc_type: "Комплект ИРД"},
  {doc_type: "Технические условия на водопровод"},
  {doc_type: "Задание на разработку проектной документации"},
  {doc_type: "Сводный сметный расчет в базовых и текущих ценах"},
  {doc_type: "Акт сдачи-приемки работ"},
  {doc_type: "Ведомость объема работ"},
  {doc_type: "Техническое задание"},
  {doc_type: "Проектная документация (стадия П)"},
  {doc_type: "Заключение о соответствии"},
  {doc_type: "График производства"},
  {doc_type: "Сводный сметный расчет по текущим ценам"}
].each do |val|
  tmp_obj = DocumentType.find_or_initialize_by(doc_type: val[:doc_type])
  tmp_obj.save
end

# инициализация словаря типов работ

[
  {task_type: "Положительное заключение МГЭ"},
  {task_type: "Регистрация в системе ЕАИСТ"},
  {task_type: "Оформление акта техприсоединения (электроснабжение)"},
  {task_type: "Получение ГПЗУ, ПП, Проектов межев."},
  {task_type: "Снос строений и вывоз строительного мусора"},
  {task_type: "Оформление ЗОС"},
  {task_type: "Утверждение ПСД"},
  {task_type: "Разработка и утверждение технического задания"},
  {task_type: "Разработка и утверждение технологического задания"},
  {task_type: "Оформление Разрешения на ввод"},
  {task_type: "Выпуск АГР"}
].each do |val|
  tmp_obj = TaskType.find_or_initialize_by(task_type: val[:task_type])
  tmp_obj.save
end

# инициализация словаря префектур

[
  {prefektura_name: "ЗАО"},
  {prefektura_name: "ЮАО"},
  {prefektura_name: "СВАО"},
  {prefektura_name: ""},
  {prefektura_name: "ТиНАО"},
  {prefektura_name: "ЦАО"},
  {prefektura_name: "ЦАО"},
  {prefektura_name: "САО"},
  {prefektura_name: "СЗАО"},
  {prefektura_name: "ЗЕЛ.АО"},
  {prefektura_name: "ЮЗАО"},
  {prefektura_name: "ЮВАО"},
  {prefektura_name: "ВАО"}
].each do |val|
  tmp_obj = Prefektura.find_or_initialize_by(prefektura_name: val[:prefektura_name])
  tmp_obj.save
end

# инициализация словаря подотраслей

[
  {podotrasl_name: "БНК"},
  {podotrasl_name: "Снос"},
  {podotrasl_name: "Дороги"},
  {podotrasl_name: "Пешеходный переход"},
  {podotrasl_name: "КНС"},
  {podotrasl_name: "Детские сады"},
  {podotrasl_name: "Жилые дома"},
  {podotrasl_name: "Сети"},
  {podotrasl_name: "Горбюджет"},
  {podotrasl_name: "Инженерия к жилым домам"},
  {podotrasl_name: "Прочие"},
  {podotrasl_name: "Физкультурно оздоровительный комплекс"},
  {podotrasl_name: "Гаражи"},
  {podotrasl_name: "Административные здания"},
  {podotrasl_name: "Объекты ФКиС"},
  {podotrasl_name: "Школы"},
  {podotrasl_name: "Инженерные объекты"},
  {podotrasl_name: "Поликлиники"},
  {podotrasl_name: ""}
].each do |val|
  tmp_obj = Podotrasl.find_or_initialize_by(podotrasl_name: val[:podotrasl_name])
  tmp_obj.save
end

[
  {otrasl_name: "Образование"},
  {otrasl_name: "Туризм"},
  {otrasl_name: ""},
  {otrasl_name: "Спорт"},
  {otrasl_name: "Социальная сфера"},
  {otrasl_name: "Безопасный город"},
  {otrasl_name: "Гаражи"},
  {otrasl_name: "Здравоохранение"},
  {otrasl_name: "Жилище"},
  {otrasl_name: "Коммунальное строительство"},
  {otrasl_name: "Экономическое развитие"}
].each do |val|
  tmp_obj = Otrasl.find_or_initialize_by(otrasl_name: val[:otrasl_name])
  tmp_obj.save
end


# создание пользователя для редактирования количества вакансий

user = User.find_by email: 'holm-van@narod.ru'

if user.blank?
  User.create({ email: 'holm-van@narod.ru', password: 'gfhf,tkkev', password_confirmation: 'gfhf,tkkev'})
  u = User.find_by email: 'holm-van@narod.ru' 
  u.role = 'vaceditor'                       
  u.save!                                    
end

# Строки 170-172 нужны потому, что созданный для cancan-а коллбэк (метод add_role в модели user.rb) всё равно
# принудительно переписывает роль созданного пользователя на дефолтную сразу после создания.
# Поэтому указывать её сразу в параметрах создаваемого юзера бесполезно, а приходится перезаписывать уже после.
