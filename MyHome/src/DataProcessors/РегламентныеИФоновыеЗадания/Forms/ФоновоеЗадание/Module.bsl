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
	
	Если Параметры.СвойстваФоновогоЗадания = Неопределено Тогда
		
		СвойстваФоновогоЗадания = РегламентныеЗаданияСлужебный
			.ПолучитьСвойстваФоновогоЗадания(Параметры.Идентификатор);
		
		Если СвойстваФоновогоЗадания = Неопределено Тогда
			ВызватьИсключение(НСтр("ru = 'Фоновое задание не найдено.'"));
		КонецЕсли;
		
		СообщенияПользователюИОписаниеИнформацииОбОшибке = РегламентныеЗаданияСлужебный
			.СообщенияИОписанияОшибокФоновогоЗадания(Параметры.Идентификатор);
			
		Если ЗначениеЗаполнено(СвойстваФоновогоЗадания.ИдентификаторРегламентногоЗадания) Тогда
			
			ИдентификаторРегламентногоЗадания
				= СвойстваФоновогоЗадания.ИдентификаторРегламентногоЗадания;
			
			НаименованиеРегламентногоЗадания
				= РегламентныеЗаданияСлужебный.ПредставлениеРегламентногоЗадания(
					СвойстваФоновогоЗадания.ИдентификаторРегламентногоЗадания);
		Иначе
			НаименованиеРегламентногоЗадания  = РегламентныеЗаданияСлужебный.ТекстНеОпределено();
			ИдентификаторРегламентногоЗадания = РегламентныеЗаданияСлужебный.ТекстНеОпределено();
		КонецЕсли;
	Иначе
		СвойстваФоновогоЗадания = Параметры.СвойстваФоновогоЗадания;
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			СвойстваФоновогоЗадания,
			"СообщенияПользователюИОписаниеИнформацииОбОшибке,
			|ИдентификаторРегламентногоЗадания,
			|НаименованиеРегламентногоЗадания");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		СвойстваФоновогоЗадания,
		"Идентификатор,
		|Ключ,
		|Наименование,
		|Начало,
		|Конец,
		|Расположение,
		|Состояние,
		|ИмяМетода");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СобытияЖурналаРегистрации(Команда)
	ОтборСобытий = Новый Структура;
	ОтборСобытий.Вставить("ДатаНачала", Начало);
	ОтборСобытий.Вставить("ДатаОкончания", Конец);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ОтборСобытий, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
