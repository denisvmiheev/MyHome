///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет, является ли переданная строка внутренней навигационной ссылкой.
//  
// Параметры:
//  Строка - Строка - навигационная ссылка.
//
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ЭтоНавигационнаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "e1cib/")
		Или СтрНачинаетсяС(Строка, "e1ccs/");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти