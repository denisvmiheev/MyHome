///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет обработчик ожидания старта автоматического резервного копирования
// в процессе работы пользователя, а также повторного оповещения после игнорировании первоначального.
//
Процедура ОбработчикДействийРезервногоКопирования() Экспорт 
	
	РезервноеКопированиеИБКлиент.ОбработчикОжиданияЗапуска();
	
КонецПроцедуры

#КонецОбласти
