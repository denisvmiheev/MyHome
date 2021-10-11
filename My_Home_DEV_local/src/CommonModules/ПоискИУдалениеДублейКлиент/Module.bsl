///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму объединения элементов справочников, планов видов характеристик, видов расчетов и счетов.
//
// Параметры:
//     ОбъединяемыеЭлементы - ТаблицаФормы
//                          - Массив из ЛюбаяСсылка
//                          - СписокЗначений - список элементов к объединению.
//                            Также можно передать произвольную коллекцию элементов с реквизитом "Ссылка".
//     ДополнительныеПараметры - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды 
//
Процедура ОбъединитьВыделенные(Знач ОбъединяемыеЭлементы, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НаборСсылок", МассивСсылок(ОбъединяемыеЭлементы));
	
	ПараметрыОткрытияФормы = Новый Структура("Владелец, Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна");
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, ДополнительныеПараметры);
	КонецЕсли;

	ОткрытьФорму(
		"Обработка.ЗаменаИОбъединениеЭлементов.Форма.ОбъединениеЭлементов",
		ПараметрыФормы,
		ПараметрыОткрытияФормы.Владелец,
		ПараметрыОткрытияФормы.Уникальность,
		ПараметрыОткрытияФормы.Окно,
		ПараметрыОткрытияФормы.НавигационнаяСсылка,
		ПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии,
		ПараметрыОткрытияФормы.РежимОткрытияОкна);
	
КонецПроцедуры

// Открывает форму замены и удаления элементов справочников, планов видов характеристик, видов расчетов и счетов.
//
// Параметры:
//     ЗаменяемыеЭлементы - ТаблицаФормы
//                        - Массив
//                        - СписокЗначений - список элементов, которые нужно заменить и удалить.
//                          Также можно передать произвольную коллекцию элементов с реквизитом "Ссылка".
//     ДополнительныеПараметры - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды 
//
Процедура ЗаменитьВыделенные(Знач ЗаменяемыеЭлементы, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НаборСсылок", МассивСсылок(ЗаменяемыеЭлементы));
	ПараметрыФормы.Вставить("ОткрытаПоСценарию");
	
	ПараметрыОткрытияФормы = Новый Структура("Владелец, Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна");
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, ДополнительныеПараметры);
	КонецЕсли;

	ОткрытьФорму(
		"Обработка.ЗаменаИОбъединениеЭлементов.Форма.ЗаменаЭлементов",
		ПараметрыФормы,
		ПараметрыОткрытияФормы.Владелец,
		ПараметрыОткрытияФормы.Уникальность,
		ПараметрыОткрытияФормы.Окно,
		ПараметрыОткрытияФормы.НавигационнаяСсылка,
		ПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии,
		ПараметрыОткрытияФормы.РежимОткрытияОкна);
	
КонецПроцедуры

// Открывает отчет о местах использования ссылок.
// В отчет не включаются вспомогательные данные, такие как наборы записей с ведущим измерением и т.п.
//
// Параметры:
//     Элементы - ТаблицаФормы
//              - ДанныеФормыКоллекция
//              - Массив из ЛюбаяСсылка
//              - СписокЗначений - список элементов для анализа.
//         Также можно передать произвольную коллекцию элементов с реквизитом "Ссылка".
//     ПараметрыОткрытия - Структура - параметры открытия формы. Состоит из необязательных полей.
//         Владелец, Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна,
//         соответствующих параметрам функции ОткрытьФорму.
// 
Процедура ПоказатьМестаИспользования(Знач Элементы, Знач ПараметрыОткрытия = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	ПараметрыФормы.Отбор.Вставить("НаборСсылок", МассивСсылок(Элементы));
	
	ПараметрыОткрытияФормы = Новый Структура("Владелец, Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна");
	Если ПараметрыОткрытия <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, ПараметрыОткрытия);
	КонецЕсли;
	
	ОткрытьФорму(
		"Отчет.МестаИспользованияСсылок.Форма",
		ПараметрыФормы,
		ПараметрыОткрытияФормы.Владелец,
		ПараметрыОткрытияФормы.Уникальность,
		ПараметрыОткрытияФормы.Окно,
		ПараметрыОткрытияФормы.НавигационнаяСсылка,
		ПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии,
		ПараметрыОткрытияФормы.РежимОткрытияОкна);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ИмяФормыОбработкиПоискИУдалениеДублей() Экспорт
	Возврат "Обработка.ПоискИУдалениеДублей.Форма.ПоискДублей";
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//   Элементы - ДанныеФормыКоллекция:
//          * Ссылка - ЛюбаяСсылка
// 	         - СписокЗначений из ЛюбаяСсылка
// 	         - ТаблицаФормы
//              * Ссылка - ЛюбаяСсылка
// 	         - Массив из ЛюбаяСсылка
// Возвращаемое значение:
//   СписокЗначений, Массив из ЛюбаяСсылка, СписокЗначений
//
Функция МассивСсылок(Знач Элементы)
	
	ТипПараметра = ТипЗнч(Элементы);
	
	Если ТипЗнч(Элементы) = Тип("ТаблицаФормы") Тогда
		
		Ссылки = Новый Массив;
		Для Каждого Элемент Из Элементы.ВыделенныеСтроки Цикл 
			ДанныеСтроки = Элементы.ДанныеСтроки(Элемент);
			Если ДанныеСтроки <> Неопределено Тогда
				Ссылки.Добавить(ДанныеСтроки.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Элементы) = Тип("ДанныеФормыКоллекция") Тогда
		
		Ссылки = Новый Массив;
		Для Каждого ДанныеСтроки Из Элементы Цикл
			Ссылки.Добавить(ДанныеСтроки.Ссылка);
		КонецЦикла;
		
	ИначеЕсли ТипПараметра = Тип("СписокЗначений") Тогда
		
		Ссылки = Новый Массив;
		Для Каждого Элемент Из Элементы Цикл
			Ссылки.Добавить(Элемент.Значение);
		КонецЦикла;
		
	Иначе
		Ссылки = Элементы;
		
	КонецЕсли;
	
	Возврат Ссылки;
КонецФункции

#КонецОбласти
