
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Кошелек) Тогда
		Кошелек = Параметры.Кошелек;
	КонецЕсли;
	
	ДатаОперации = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьОформлениеНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	СтатьяРасходовПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	мх_СобытияФормВызовСервера.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.АналитикаРасходов, СтатьяРасходов);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура СканироватьЧек(Команда)

	#Если МобильноеПриложениеКлиент ИЛИ МобильныйКлиент Тогда
	Оповещение = Новый ОписаниеОповещения("СканироватьШтрихкодЗавершение", ЭтотОбъект);
	мх_СканированиеКлиент.СканироватьШтрихкод(Оповещение);
	#Иначе
	Возврат;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРасход(Команда)

	Если Не РеквизитыРасходаЗаполнены() Тогда
		Возврат;
	КонецЕсли;

	ПараметрыРасхода = НовыеПараметрыРасхода();

	РасходУжеСуществует = РасходУжеСуществует(ПараметрыРасхода);

	Если РасходУжеСуществует Тогда
		ТекстВопроса = Нстр("ru = 'В системе уже существуют данные о расходе с такими параметрами.
							|Добавить еще раз?'");
		ПараметрыОповещения = Новый Структура("ПараметрыРасхода", ПараметрыРасхода);
		Оповещение = Новый ОписаниеОповещения("ДобавитьРасходПослеВопроса", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	Иначе
		ДобавитьРасходНаКлиенте(ПараметрыРасхода);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Расход

&НаКлиенте
Процедура ДобавитьРасходНаКлиенте(ПараметрыРасхода)

	Результат = ДобавитьРасходНаСервере(ПараметрыРасхода);

	Если Результат.Успех Тогда
		ПоказатьОповещениеПользователя("Расход добавлен");
		Оповестить("ОбновитьРабочийСтол");
		
		Если НЕ ДобавитьЕщеОдинРасход Тогда
			Закрыть();
		Иначе
			ЭтотОбъект.ТекущийЭлемент = Элементы.Сумма;
			Сумма = 0;
			СтатьяРасходов = Неопределено;
			АналитикаРасходов = Неопределено;
		КонецЕсли;
		
	Иначе
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРасходПослеВопроса(Результат, ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	ДобавитьРасходНаКлиенте(ДопПараметры.ПараметрыРасхода);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьРасходНаСервере(ПараметрыРасхода)

	Возврат Документы.мх_РегистрацияРасходов.ДобавитьРасход(ПараметрыРасхода);

КонецФункции

&НаКлиенте
Функция РеквизитыРасходаЗаполнены()

	РеквизитыЗаполнены = Истина;

	Если Не ЗначениеЗаполнено(Кошелек) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан кошелек", , "Кошелек", , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ДатаОперации) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана дата", , "ДатаОперации", , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(СтатьяРасходов) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана статья расходов", , "СтатьяРасходов", , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Сумма) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана сумма", , "Сумма", , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;

	Возврат РеквизитыЗаполнены;

КонецФункции

&НаСервереБезКонтекста
Функция РасходУжеСуществует(ПараметрыРасхода)

	Возврат Документы.мх_РегистрацияРасходов.РасходСуществует(ПараметрыРасхода);

КонецФункции

&НаКлиенте
Функция НовыеПараметрыРасхода()

	ПараметрыРасхода = Новый Структура;
	ПараметрыРасхода.Вставить("Кошелек"				, Кошелек);
	ПараметрыРасхода.Вставить("СтатьяРасходов"		, СтатьяРасходов);
	ПараметрыРасхода.Вставить("АналитикаРасходов"	, АналитикаРасходов);
	ПараметрыРасхода.Вставить("Сумма"				, Сумма);
	ПараметрыРасхода.Вставить("ДатаОперации"		, ДатаОперации);
	ПараметрыРасхода.Вставить("Регистратор"			, Неопределено);
	ПараметрыРасхода.Вставить("Комментарий"			, Комментарий);

	Возврат ПараметрыРасхода;

КонецФункции

#КонецОбласти

#Область Сканирование

&НаКлиенте
Процедура СканироватьШтрихкодЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Успех = Ложь Тогда
		Возврат;
	КонецЕсли;

	РезультатЧтения = мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.ПрочитатьДанныеШтрихкодаЧека(Результат.Штрихкод);

	Если Не РезультатЧтения.Успех Тогда
		ПоказатьПредупреждение( , РезультатЧтения.ОписаниеОшибки);
		Возврат;
	КонецЕсли;

	ДанныеЧека = мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.ДанныеЧека(РезультатЧтения);

	Сумма = ДанныеЧека.Сумма;
	ДатаОперации = ДанныеЧека.Дата;
КонецПроцедуры

#КонецОбласти

#Область Оформление

&НаКлиенте
Процедура УстановитьОформлениеНаКлиенте()

#Если МобильноеПриложениеКлиент Или МобильныйКлиент Тогда
	Элементы.СканироватьЧек.Видимость = Истина;
#Иначе
	Элементы.СканироватьЧек.Видимость = Ложь;
#КонецЕсли

КонецПроцедуры

#КонецОбласти

#КонецОбласти