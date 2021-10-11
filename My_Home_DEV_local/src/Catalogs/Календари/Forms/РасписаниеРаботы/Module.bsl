///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасписаниеДня = Параметры.РасписаниеРаботы;
	УточнитьФорматПолейВремени();
	
	Для Каждого ОписаниеИнтервала Из РасписаниеДня Цикл
		ЗаполнитьЗначенияСвойств(РасписаниеРаботы.Добавить(), ОписаниеИнтервала);
	КонецЦикла;
	РасписаниеРаботы.Сортировать("ВремяНачала");
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		Элементы.ФормаОтмена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасписаниеРаботыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
		
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ГрафикиРаботыКлиент.ВосстановитьПорядокСтрокКоллекцииПослеРедактирования(РасписаниеРаботы, "ВремяНачала", Элемент.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция РасписаниеДня()
	
	Отказ = Ложь;
	
	РасписаниеДня = Новый Массив;
	
	ОкончаниеДня = Неопределено;
	
	Для Каждого СтрокаРасписания Из РасписаниеРаботы Цикл
		ИндексСтроки = РасписаниеРаботы.Индекс(СтрокаРасписания);
		Если СтрокаРасписания.ВремяНачала > СтрокаРасписания.ВремяОкончания 
			И ЗначениеЗаполнено(СтрокаРасписания.ВремяОкончания) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Время начала больше времени окончания'"), ,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("РасписаниеРаботы[%1].ВремяОкончания", ИндексСтроки), ,
				Отказ);
		КонецЕсли;
		Если СтрокаРасписания.ВремяНачала = СтрокаРасписания.ВремяОкончания Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Длительность интервала не определена'"), ,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("РасписаниеРаботы[%1].ВремяОкончания", ИндексСтроки), ,
				Отказ);
		КонецЕсли;
		Если ОкончаниеДня <> Неопределено Тогда
			Если ОкончаниеДня > СтрокаРасписания.ВремяНачала 
				Или Не ЗначениеЗаполнено(ОкончаниеДня) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Обнаружены пересекающиеся интервалы'"), ,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("РасписаниеРаботы[%1].ВремяНачала", ИндексСтроки), ,
					Отказ);
			КонецЕсли;
		КонецЕсли;
		ОкончаниеДня = СтрокаРасписания.ВремяОкончания;
		РасписаниеДня.Добавить(Новый Структура("ВремяНачала, ВремяОкончания", СтрокаРасписания.ВремяНачала, СтрокаРасписания.ВремяОкончания));
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РасписаниеДня;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	РасписаниеДня = РасписаниеДня();
	Если РасписаниеДня = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(Новый Структура("РасписаниеРаботы", РасписаниеДня));
	
КонецПроцедуры

&НаСервере
Процедура УточнитьФорматПолейВремени()
	
	ФорматВремени = НСтр("ru = 'ДФ=ЧЧ:мм; ДП='");
	
	Элементы.РасписаниеРаботыВремяНачала.Формат = ФорматВремени;
	Элементы.РасписаниеРаботыВремяНачала.ФорматРедактирования = ФорматВремени;
	
	Элементы.РасписаниеРаботыВремяОкончания.Формат = ФорматВремени;
	Элементы.РасписаниеРаботыВремяОкончания.ФорматРедактирования = ФорматВремени;
	
КонецПроцедуры

#КонецОбласти
