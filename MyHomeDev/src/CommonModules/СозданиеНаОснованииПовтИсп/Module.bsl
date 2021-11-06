///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОбъектыСКомандамиСозданияНаОсновании() Экспорт
	
	Объекты = Новый Массив;
	ИнтеграцияПодсистемБСП.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты);
	СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты);
	
	Результат = Новый Соответствие;
	Для Каждого ОбъектМетаданных Из Объекты Цикл
		Результат.Вставить(ОбъектМетаданных.ПолноеИмя(), Истина);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти

