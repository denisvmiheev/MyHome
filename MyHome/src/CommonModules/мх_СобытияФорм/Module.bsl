#Область ПрограммныйИнтерфейс

Процедура УстановитьОграничениеТипаДляАналитикиДоходовРасходов(ЭлементФормыАналитика, ЗначениеСтатьи, Аналитика) Экспорт

	РеквизитыСтатьи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗначениеСтатьи, "ТипЗначения, ТипАналитикиПоУмолчанию");
	
	ТипАналитики = РеквизитыСтатьи.ТипЗначения;

	Если ТипАналитики <> Неопределено
		И ТипАналитики <> NULL Тогда
		ОграничениеТипа = ТипАналитики;
	Иначе
		ОграничениеТипа = Новый ОписаниеТипов;
	КонецЕсли;

	ЭлементФормыАналитика.ОграничениеТипа = ОграничениеТипа;
	
	Аналитика = РеквизитыСтатьи.ТипАналитикиПоУмолчанию;
	
	Если Аналитика <> Неопределено Тогда
		ЭлементФормыАналитика.ПодсказкаВвода = Строка(ТипЗнч(Аналитика));
	Иначе
		ЭлементФормыАналитика.ПодсказкаВвода = "";
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКэшированныеЗначенияДляСвязиТиповДоходовРасходов(Форма) Экспорт

	КэшированныеЗначения = Форма.КэшированныеЗначения;

	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = Новый Структура;
	КонецЕсли;

	КэшированныеЗначения.Вставить("ВидДвиженияДоход", ПредопределенноеЗначение("Перечисление.ВидыДвиженийДенежныхСредств.Доход"));
	КэшированныеЗначения.Вставить("ВидДвиженияРасход", ПредопределенноеЗначение("Перечисление.ВидыДвиженийДенежныхСредств.Расход"));
	КэшированныеЗначения.Вставить("ВидДвиженияПеремещение", ПредопределенноеЗначение(
		"Перечисление.ВидыДвиженийДенежныхСредств.Перемещение"));

	МассивТиповСтатейЗатрат = Новый Массив;
	МассивТиповСтатейЗатрат.Добавить(Тип("Строка"));
	МассивТиповСтатейЗатрат.Добавить(Тип("ПланВидовХарактеристикСсылка.мх_СтатьиДоходов"));
	МассивТиповСтатейЗатрат.Добавить(Тип("ПланВидовХарактеристикСсылка.мх_СтатьиРасходов"));

	МассивТиповДоходы = Новый Массив;
	МассивТиповДоходы.Добавить(МассивТиповСтатейЗатрат[1]);

	МассивТиповРасходы = Новый Массив;
	МассивТиповРасходы.Добавить(МассивТиповСтатейЗатрат[2]);

	КэшированныеЗначения.Вставить("ОграничениеТипаДоход", Новый ОписаниеТипов(МассивТиповДоходы));
	КэшированныеЗначения.Вставить("ОграничениеТипаРасход", Новый ОписаниеТипов(МассивТиповРасходы));
	КэшированныеЗначения.Вставить("ОграничениеТипаСтатьиЗатрат", Новый ОписаниеТипов(МассивТиповСтатейЗатрат));

	Форма.КэшированныеЗначения = КэшированныеЗначения;

КонецПроцедуры

Функция ФормаБудетПереопределенаПриИзмененииИнтерфейса(Форма) Экспорт
	
	Если НЕ ЭтоФормаНачальнойСтраницы(Форма) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НомерСеанса = мх_ПользователиПовтИсп.НомерТекущегоСеанса();
	ДанныеСеанса = РегистрыСведений.мх_ДанныеСеансовИнформационнойБазы.ДанныеСеанса(НомерСеанса, "ИнтерфейсОпределен");
	
	ИнтерфейсОпределен = (ДанныеСеанса.ИнтерфейсОпределен = Истина);
	
	Возврат НЕ ИнтерфейсОпределен;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
 
// Это форма начальной страницы.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
// 
// Возвращаемое значение:
//  Булево - Это форма начальной страницы
Функция ЭтоФормаНачальнойСтраницы(Форма)
	
	ФормыНачальнойСтраницы = мх_СобытияФормПовтИсп.ИменаФормНачальнойСтраницы();
	
	ЭтоФормаНачальнойСтраницы = (ФормыНачальнойСтраницы.Найти(Форма.ИмяФормы) <> Неопределено);
	
	Возврат ЭтоФормаНачальнойСтраницы;
	
КонецФункции

#КонецОбласти
