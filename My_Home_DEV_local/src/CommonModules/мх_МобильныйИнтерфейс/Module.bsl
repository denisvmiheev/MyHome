
#Область ПрограммныйИнтерфейс

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка, ИмяОбъектаМетаданных) Экспорт

	ИспользуетсяМобильныйИнтерфейс = мх_ПользователиПовтИсп.ИспользуетсяМобильныйИнтерфейс();
	
	Если ИспользуетсяМобильныйИнтерфейс Тогда
		
		Если ВидФормы = "ФормаОбъекта" Тогда
			ИмяФормы = "ФормаДокумента";
		Иначе
			ИмяФормы = ВидФормы;
		КонецЕсли;
		
		ИмяФормы = ИмяФормы + "МобильныйИнтерфейс";
		
		НоваяФорма = НайтиФормуОбъектаМетаданных(ИмяОбъектаМетаданных, ИмяФормы);
		
		Если НоваяФорма <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = ИмяФормы;
		КонецЕсли;
		
	КонецЕсли;		

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиФормуОбъектаМетаданных(ИмяОбъектаМетаданных, ИмяФормы)
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
	
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		НайденнаяФорма = МетаданныеОбъекта.Формы.Найти(ИмяФормы);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат НайденнаяФорма;
	
КонецФункции

#КонецОбласти