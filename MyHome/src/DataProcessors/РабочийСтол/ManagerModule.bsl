#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область Блоки

#Область БлокРасходы

Процедура ДобавитьРасходы(ТаблицаБлоков)
	
	ИмяБлока = "Расходы";
	СинонимБлока = НСтр("ru = 'Расходы'");
	ПроцедураПолученияДанных = "Обработки.РабочийСтол.ПолучитьРасходы";
	ПроцедураОбновленияДанных = "Обработки.РабочийСтол.ОбновитьРасходы";
		
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("Расходы_Заголовок");
	Реквизиты.Добавить("Расходы_Период");
	Реквизиты.Добавить("Расходы_СуммаЗаПериод");
	Реквизиты.Добавить("Расходы_ДобавитьРасход");
	
	СтрокаРеквизиты = СтрСоединить(Реквизиты, ", ");
	
	ДобавитьБлок(ТаблицаБлоков, ИмяБлока, СинонимБлока, ПроцедураПолученияДанных, ПроцедураОбновленияДанных, СтрокаРеквизиты);
	
КонецПроцедуры

Процедура ПолучитьРасходы(Параметры) Экспорт
	
	Период = Параметры.ПериодОтчета;
	
	Результат = Новый Структура;
	
	ЗаголовокБлока = ЗаголовокБлока(НСтр("ru = 'Расходы'"));
	Результат.Вставить("Расходы_Заголовок", ЗаголовокБлока);
	
	ПредставлениеПериода = Новый ФорматированнаяСтрока(Строка(Период));
	Результат.Вставить("Расходы_Период", ПредставлениеПериода);
	
	СуммаРасхода		 = СуммаРасходаЗаПериод(Период.ДатаНачала, Период.ДатаОкончания);
	ПредставлениеСуммы	 = мх_РабочийСтол.ПредставлениеСуммы(СуммаРасхода, " руб.", Истина);

	Результат.Вставить("Расходы_СуммаЗаПериод", ПредставлениеСуммы);
	
	ПоместитьВоВременноеХранилище(Результат, Параметры.АдресХранилища);	
	
КонецПроцедуры

Процедура ОбновитьРасходы(Параметры) Экспорт
	
	ПолучитьРасходы(Параметры);
		
КонецПроцедуры

Функция СуммаРасходаЗаПериод(ДатаНачала, ДатаОкончания)

	СуммаРасхода = 0;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходыОбороты.СуммаОборот
	|ИЗ
	|	РегистрНакопления.Расходы.Обороты(&ДатаНачала, &ДатаОкончания,,) КАК РасходыОбороты";

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		СуммаРасхода = Выборка.СуммаОборот;
	КонецЕсли;

	Возврат СуммаРасхода;

КонецФункции

#КонецОбласти

#Область БлокБалансБюджета

Процедура ДобавитьБалансБюджета(ТаблицаБлоков)
	
	ИмяБлока = "БалансБюджета";
	СинонимБлока = НСтр("ru = 'Баланс бюджета'");
	ПроцедураПолученияДанных = "Обработки.РабочийСтол.ПолучитьБалансБюджета";
	ПроцедураОбновленияДанных = "Обработки.РабочийСтол.ОбновитьБалансБюджета";
		
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("БалансБюджета_Заголовок");
	Реквизиты.Добавить("БалансБюджета_Баланс");
	Реквизиты.Добавить("БалансБюджета_Наличные");
	Реквизиты.Добавить("БалансБюджета_Кредитные");
	Реквизиты.Добавить("БалансБюджета_Общий");
	
	СтрокаРеквизиты = СтрСоединить(Реквизиты, ", ");
	
	ДобавитьБлок(ТаблицаБлоков, ИмяБлока, СинонимБлока, ПроцедураПолученияДанных, ПроцедураОбновленияДанных, СтрокаРеквизиты);
	
КонецПроцедуры

Процедура ПолучитьБалансБюджета(Параметры) Экспорт
	
	Период = Параметры.ПериодОтчета;
	ДатаПроверки = Мин(ТекущаяДата(), Период.ДатаОкончания);
	
	Результат = Новый Структура;
	
	ШаблонЗаголовкаБаланса = НСтр("ru = 'Баланс бюджета (%1)'");
	ЗаголовокБлока = СтрШаблон(ШаблонЗаголовкаБаланса, Формат(ДатаПроверки, "ДФ=dd.MM.yyyy;"));
	ЗаголовокБлока = ЗаголовокБлока(ЗаголовокБлока);
	Результат.Вставить("БалансБюджета_Заголовок", ЗаголовокБлока);
	
	СуммаБаланса = ПланированиеБюджетаСервер.ОстатокБюджетаНаДату(ДатаПроверки);
	ПредставлениеБаланса = мх_РабочийСтол.ПредставлениеСуммы(СуммаБаланса, " руб.", Истина);
	Результат.Вставить("БалансБюджета_Баланс", ПредставлениеБаланса);
	
	СуммаБалансНаличные = ОстатокНаличныхДенежныхСредств(ДатаПроверки);
	ПредставлениеБаланса = мх_РабочийСтол.ПредставлениеСуммы(СуммаБалансНаличные, " руб.", Истина);
	Результат.Вставить("БалансБюджета_Наличные", ПредставлениеБаланса);
	
	СуммаБалансКредитные = ДолгиПоКредитнымСчетам(ДатаПроверки);
	ПредставлениеБаланса = мх_РабочийСтол.ПредставлениеСуммы(-СуммаБалансКредитные, " руб.", Истина);
	Результат.Вставить("БалансБюджета_Кредитные", ПредставлениеБаланса);
	
	СуммаБалансОбщий = СуммаБалансНаличные - СуммаБалансКредитные;
	ПредставлениеБаланса = мх_РабочийСтол.ПредставлениеСуммы(СуммаБалансОбщий, " руб.", Истина);
	Результат.Вставить("БалансБюджета_Общий", ПредставлениеБаланса);

	ПоместитьВоВременноеХранилище(Результат, Параметры.АдресХранилища);	
	
КонецПроцедуры

Процедура ОбновитьБалансБюджета(Параметры) Экспорт
	
	ПолучитьБалансБюджета(Параметры);	

КонецПроцедуры

// Остаток наличных денежных средств.
// 
// Параметры:
//  Период - Дата - Дата, на которую необходимо получить остатки. Если не указана, то текущаядата
// 
// Возвращаемое значение:
//  Число - Остаток денежных средств
Функция ОстатокНаличныхДенежныхСредств(Знач Период = Неопределено) Экспорт
	
	Остаток = 0;
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	ТипыКошельков = КошелькиИСчета.ТипыКошельковСобственныхСредств();
	Кошельки = КошелькиИСчета.ИспользуемыеКошелькиПоТипу(ТипыКошельков);
	
	Остатки = Справочники.КошелькиИСчета.ОстаткиКошельков(Кошельки, Период, Ложь);
	
	Остаток = Остатки.Итог("Баланс");
	
	Возврат Остаток;
	
КонецФункции

// Долги по кредитным счетам
// 
// Параметры:
//  Период - Дата - Дата, на которую необходимо получить остатки. Если не указана, то текущаядата
// 
// Возвращаемое значение:
//  Число - Долги по кредитным счетам
Функция ДолгиПоКредитнымСчетам(Знач Период = Неопределено) Экспорт
	
	Долг = 0;
		
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	ТипыКошельков = КошелькиИСчета.ТипыКошельковЗаемныхСредств();
	Кошельки = КошелькиИСчета.ИспользуемыеКошелькиПоТипу(ТипыКошельков);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Кошельки", Кошельки);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ДвиженияДенежныхСредствОстатки.Кошелек.КредитныйЛимит - ДвиженияДенежныхСредствОстатки.СуммаОстаток) КАК Долг
	|ИЗ
	|	РегистрНакопления.ДвиженияДенежныхСредств.Остатки(&Период, Кошелек В (&Кошельки)) КАК ДвиженияДенежныхСредствОстатки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Долг = Выборка.Долг;
	КонецЕсли;
	
	Возврат Долг;
	
КонецФункции

#КонецОбласти

#Область ОстаткиПоКошелькам

Процедура ДобавитьОстаткиКошельков(ТаблицаБлоков)
	
	ИмяБлока = "ОстаткиКошельков";
	СинонимБлока = НСтр("ru = 'Остатки кошельков'");
	ПроцедураПолученияДанных = "Обработки.РабочийСтол.ПолучитьОстаткиКошельков";
	ПроцедураОбновленияДанных = "Обработки.РабочийСтол.ОбновитьОстаткиКошельков";
		
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("ОстаткиКошельков_Заголовок");
	
	СтрокаРеквизиты = СтрСоединить(Реквизиты, ", ");
	
	ДобавитьБлок(ТаблицаБлоков, ИмяБлока, СинонимБлока, ПроцедураПолученияДанных, ПроцедураОбновленияДанных, СтрокаРеквизиты);
	
КонецПроцедуры

Процедура ПолучитьОстаткиКошельков(Параметры) Экспорт
	
	Период = Параметры.ПериодОтчета;
	ДатаПроверки = Мин(ТекущаяДата(), Период.ДатаОкончания);
	
	Результат = Новый Структура;
	
	ЗаголовокБлока = ЗаголовокБлока(НСтр("ru = 'Остатки кошельков'"));
	Результат.Вставить("ОстаткиКошельков_Заголовок", ЗаголовокБлока);
	
	Кошельки = КошелькиДляОтображенияНаРабочемСтоле();
	ОстаткиКошельков = Справочники.КошелькиИСчета.ОстаткиКошельков(Кошельки, ДатаПроверки, Ложь);
	
	Результат.Вставить("ОстаткиКошельков_ДанныеОстатков", ОстаткиКошельков);

	ПоместитьВоВременноеХранилище(Результат, Параметры.АдресХранилища);	
	
КонецПроцедуры

Процедура ОбновитьОстаткиКошельков(Параметры) Экспорт

	ПолучитьОстаткиКошельков(Параметры);
	
КонецПроцедуры

Функция КошелькиДляОтображенияНаРабочемСтоле() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КошелькиИСчета.Ссылка КАК Кошелек
	|ИЗ
	|	Справочник.КошелькиИСчета КАК КошелькиИСчета
	|ГДЕ
	|	НЕ КошелькиИСчета.ПометкаУдаления
	|	И КошелькиИСчета.ОтображатьОстатокНаРабочемСтоле
	|УПОРЯДОЧИТЬ ПО
	|	КошелькиИСчета.Наименование";

	Кошельки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Кошелек");

	Возврат Кошельки;

КонецФункции

#КонецОбласти

Процедура ЗаполнитьТаблицуБлоков(КоллекцияБлоков) Экспорт
	
	ИменаБлоков = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияБлоков, "Имя", Истина);
		
	ТаблицаБлоков = НоваяТаблицаБлоков();
	
	ДобавитьРасходы(ТаблицаБлоков);
	
	ДобавитьБалансБюджета(ТаблицаБлоков);
	
	ДобавитьОстаткиКошельков(ТаблицаБлоков);
	
	Для Каждого Блок Из ТаблицаБлоков Цикл
		Если ИменаБлоков.Найти(Блок.Имя) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(КоллекцияБлоков.Добавить(), Блок);
			ИменаБлоков.Добавить(Блок.Имя);
		Иначе
			// Блок переопределен в расширении
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция НоваяТаблицаБлоков()
	
	ТаблицаБлоков = Новый ТаблицаЗначений;
	
	Колонки = ТаблицаБлоков.Колонки;
	
	Колонки.Добавить("Пометка",                   Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("Имя",                       ОбщегоНазначения.ОписаниеТипаСтрока(150));
	Колонки.Добавить("Синоним",                   ОбщегоНазначения.ОписаниеТипаСтрока(150));
	Колонки.Добавить("ПроцедураПолученияДанных",  ОбщегоНазначения.ОписаниеТипаСтрока(0));
	Колонки.Добавить("ПроцедураОбновленияДанных", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	Колонки.Добавить("РеквизитыФормы",            ОбщегоНазначения.ОписаниеТипаСтрока(0));
	Колонки.Добавить("ЦветФона",                  Новый ОписаниеТипов("Цвет"));
	Колонки.Добавить("Порядок",                   ОбщегоНазначения.ОписаниеТипаЧисло(3));
	
	Возврат ТаблицаБлоков;
	
КонецФункции

Процедура ДобавитьБлок(ТаблицаБлоков, Имя, Синоним, ПроцедураПолученияДанных, ПроцедураОбновленияДанных, РеквизитыФормы, Порядок = 100)
	
	НовыйБлок = ТаблицаБлоков.Добавить();
	НовыйБлок.Имя                       = Имя;
	НовыйБлок.Синоним                   = Синоним;
	НовыйБлок.ПроцедураПолученияДанных  = ПроцедураПолученияДанных;
	НовыйБлок.ПроцедураОбновленияДанных = ПроцедураОбновленияДанных;
	НовыйБлок.РеквизитыФормы            = РеквизитыФормы;
	НовыйБлок.Порядок                   = Порядок;
	
КонецПроцедуры

// Заменяет пробелы в строке на неразрывные пробелы для блокировки переносов в браузере
//
Функция СтрокаБезПереносов(ИсходнаяСтрока)
	
	// Для того чтобы строка правильно переносилась в веб-клиенте,
	// вместо запятой используем символ - U+201A:Single Low-9 Quotation Mark (Keystroke: Alt+0130)
	ИсходнаяСтрока = СтрЗаменить(ИсходнаяСтрока, ",", "‚");
	Возврат СтрЗаменить(ИсходнаяСтрока, " ", Символы.НПП);
	
КонецФункции

Функция ЗаголовокБлока(ТекстЗаголовка)
	
	Шрифт = ШрифтыСтиля.ВажнаяНадписьШрифт;
	ЦветТекста = ЦветаСтиля.РезультатУспехЦвет;
	
	Возврат Новый ФорматированнаяСтрока(ТекстЗаголовка, Шрифт, ЦветТекста);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли