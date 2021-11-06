///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает ссылки на узлы с очередью меньшей, чем переданная.
//
// Параметры:
//  Очередь	 - Число - очередь обработки данных.
// 
// Возвращаемое значение:
//   Массив из ПланОбменаСсылка.ОбновлениеИнформационнойБазы. 
//
Функция УзлыМеньшейОчереди(Очередь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
	|ГДЕ
	|	ОбновлениеИнформационнойБазы.Очередь < &Очередь
	|	И НЕ ОбновлениеИнформационнойБазы.ЭтотУзел
	|	И ОбновлениеИнформационнойБазы.Очередь <> 0";
	
	Запрос.УстановитьПараметр("Очередь", Очередь);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Ищет узел плана обмена по очереди и возвращает ссылку на него.
// Если узла еще нет, то он будет создан.
//
// Параметры:
//  Очередь	 - Число - очередь обработки данных.
// 
// Возвращаемое значение:
//  ПланОбменаСсылка.ОбновлениеИнформационнойБазы.
//
Функция УзелПоОчереди(Очередь) Экспорт
	
	Если ТипЗнч(Очередь) <> Тип("Число") Или Очередь = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно получить узел плана обмена ОбновлениеИнформационнойБазы, т.к. не передан номер очереди.'");
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
		|ГДЕ
		|	ОбновлениеИнформационнойБазы.Очередь = &Очередь
		|	И НЕ ОбновлениеИнформационнойБазы.ЭтотУзел");
	Запрос.УстановитьПараметр("Очередь", Очередь);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Узел = Выборка.Ссылка;
	Иначе
		НачатьТранзакцию();
		
		Попытка
			Блокировки = Новый БлокировкаДанных;
			Блокировка = Блокировки.Добавить("ПланОбмена.ОбновлениеИнформационнойБазы");
			Блокировка.УстановитьЗначение("Очередь", Очередь);
			Блокировки.Заблокировать();
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				Узел = Выборка.Ссылка;
			Иначе
				ОчередьСтрокой = Строка(Очередь);
				УзелОбъект = СоздатьУзел();
				УзелОбъект.Очередь = Очередь;
				УзелОбъект.УстановитьНовыйКод(ОчередьСтрокой);
				УзелОбъект.Наименование = ОчередьСтрокой;
				УзелОбъект.Записать();
				Узел = УзелОбъект.Ссылка;
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Узел;
	
КонецФункции

#КонецОбласти

#КонецЕсли