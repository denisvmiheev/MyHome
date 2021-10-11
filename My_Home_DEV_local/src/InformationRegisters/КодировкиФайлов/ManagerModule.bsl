///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает кодировку версии файла.
//
// Параметры:
//   ВерсияСсылка - ОпределяемыйТип.ПрисоединенныеФайлы - версия файла.
//
// Возвращаемое значение:
//   Строка
//
Функция КодировкаВерсииФайла(ВерсияСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.КодировкиФайлов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Файл = ВерсияСсылка;
	МенеджерЗаписи.Прочитать();
	
	Возврат МенеджерЗаписи.Кодировка;
	
КонецФункции

// Записывает кодировку версии файла.
//
// Параметры:
//   ВерсияСсылка - ОпределяемыйТип.ПрисоединенныеФайлы - ссылка на версию файла.
//   Кодировка - Строка - новая кодировка версии файла.
//
Процедура ЗаписатьКодировкуВерсииФайла(ВерсияСсылка, Кодировка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.КодировкиФайлов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Файл = ВерсияСсылка;
	МенеджерЗаписи.Кодировка = Кодировка;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

// Автоматически определяет и возвращает кодировку текстового файла.
//
// Параметры:
//  ПрисоединенныйФайл - ОпределяемыйТип.ПрисоединенныеФайлы
//  Расширение         - Строка - расширение файла.
//
// Возвращаемое значение:
//  Строка
//
Функция ОпределитьКодировкуФайла(ПрисоединенныйФайл, Расширение) Экспорт
	
	Кодировка = КодировкаВерсииФайла(ПрисоединенныйФайл);
	Если ЗначениеЗаполнено(Кодировка) Тогда
		Возврат Кодировка;
	КонецЕсли;
		
	ОбщиеНастройки = РаботаСФайламиСлужебныйПовтИсп.НастройкиРаботыСФайлами().ОбщиеНастройки;
	АвтоопределениеКодировки = РаботаСФайламиСлужебныйКлиентСервер.РасширениеФайлаВСписке(
		ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, Расширение);
	Если Не АвтоопределениеКодировки Тогда
		Возврат Кодировка;
	КонецЕсли;
		
	ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ПрисоединенныйФайл, Ложь);
	Если ДвоичныеДанные <> Неопределено Тогда
		Кодировка = КодировкаИзДвоичныхДанных(ДвоичныеДанные);
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Если СтрЗаканчиваетсяНа(НРег(Расширение), "xml") Тогда
				Кодировка = КодировкаИзОбъявленияXML(ДвоичныеДанные);
			Иначе
				Кодировка = КодировкаИзСоответствияАлфавиту(ДвоичныеДанные);
			КонецЕсли;
			
			Если НРег(Кодировка) = "utf-8" Тогда
				Кодировка = НРег(Кодировка) + "_WithoutBOM";
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	Возврат Кодировка;
	
КонецФункции

// Возвращает кодировку, полученную из двоичных данных файла, если
// файл содержит сигнатуру BOM в начале.
//
// Параметры:
//  ДвоичныеДанные - двоичные данные файла.
//
// Возвращаемое значение:
//  Строка - кодировка файла. Если файл не содержит сигнатуру BOM, 
//           возвращает пустую строку.
//
Функция КодировкаИзДвоичныхДанных(ДвоичныеДанные)

	ЧтениеДанных        = Новый ЧтениеДанных(ДвоичныеДанные);
	БуферДвоичныхДанных = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(5);
	
	Возврат КодировкаBOM(БуферДвоичныхДанных);

КонецФункции

// Возвращает кодировку, полученную из двоичных данных файла, если
// файл содержит объявление XML.
//
// Параметры:
//  ДвоичныеДанные - двоичные данные файла.
//
// Возвращаемое значение:
//  КодировкаXML - Строка - кодировка файла. Если невозможно прочитать 
//                          объявление XML, возвращает пустую строку.
//
Функция КодировкаИзОбъявленияXML(ДвоичныеДанные)
	
	БуферДвоичныхДанных = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные);
	ПотокВПамяти = Новый ПотокВПамяти(БуферДвоичныхДанных);
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(ПотокВПамяти);
	Попытка
		ЧтениеXML.ПерейтиКСодержимому();
		КодировкаXML = ЧтениеXML.КодировкаXML;
	Исключение
		КодировкаXML = "";
	КонецПопытки;
	ЧтениеXML.Закрыть();
	ПотокВПамяти.Закрыть();
	
	Возврат КодировкаXML;
	
КонецФункции

// Возвращает кодировку текста, полученную из сигнатуры BOM в начале.
//
// Параметры:
//  БуферДвоичныхДанных - коллекция байтов для определения кодировки.
//
// Возвращаемое значение:
//  Кодировка - Строка - кодировка файла. Если файл не содержит сигнатуру BOM, 
//                       возвращает пустую строку.
//
Функция КодировкаBOM(БуферДвоичныхДанных)
	
	ПрочитанныеБайты = Новый Массив(5);
	Для Индекс = 0 По 4 Цикл
		Если Индекс < БуферДвоичныхДанных.Размер Тогда
			ПрочитанныеБайты[Индекс] = БуферДвоичныхДанных[Индекс];
		Иначе
			ПрочитанныеБайты[Индекс] = ЧислоИзШестнадцатеричнойСтроки("0xA5");
		КонецЕсли;
	КонецЦикла;
	
	Если ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xFE")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xFF") Тогда
		Кодировка = "UTF-16BE";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xFF")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xFE") Тогда
		Если ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x00")
			И ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x00") Тогда
			Кодировка = "UTF-32LE";
		Иначе
			Кодировка = "UTF-16LE";
		КонецЕсли;
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xEF")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xBB")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0xBF") Тогда
		Кодировка = "UTF-8";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0x00")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0x00")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0xFE")
		И ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0xFF") Тогда
		Кодировка = "UTF-32BE";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0x0E")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xFE")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0xFF") Тогда
		Кодировка = "SCSU";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xFB")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xEE")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x28") Тогда
		Кодировка = "BOCU-1";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0x2B")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0x2F")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x76")
		И (ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x38")
			Или ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x39")
			Или ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x2B")
			Или ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x2F")) Тогда
		Кодировка = "UTF-7";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xDD")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0x73")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x66")
		И ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x73") Тогда
		Кодировка = "UTF-EBCDIC";
	Иначе
		Кодировка = "";
	КонецЕсли;
	
	Возврат Кодировка;
	
КонецФункции

// Возвращает наиболее подходящую кодировку текста, полученную путем сравнения с алфавитом.
//
// Параметры:
//  ДанныеТекста - ДвоичныеДанные - двоичные данные файла.
//
// Возвращаемое значение:
//  СоответствующаяКодировка - Строка - кодировка файла.
//
Функция КодировкаИзСоответствияАлфавиту(ДанныеТекста)
	
	Кодировки = РаботаСФайламиСлужебный.Кодировки();
	Кодировки.Удалить(Кодировки.НайтиПоЗначению("utf-8_WithoutBOM"));
	
	КодировкаKOI8R = Кодировки.НайтиПоЗначению("koi8-r");
	Кодировки.Сдвинуть(КодировкаKOI8R, -Кодировки.Индекс(КодировкаKOI8R));
	
	КодировкаWin1251 = Кодировки.НайтиПоЗначению("windows-1251");
	Кодировки.Сдвинуть(КодировкаWin1251, -Кодировки.Индекс(КодировкаWin1251));
	
	КодировкаUTF8 = Кодировки.НайтиПоЗначению("utf-8");
	Кодировки.Сдвинуть(КодировкаUTF8, -Кодировки.Индекс(КодировкаUTF8));
	
	СоответствующаяКодировка = "";
	МаксимальноеСоответствиеКодировки = 0;
	Для Каждого Кодировка Из Кодировки Цикл
		
		СоответствиеКодировки = ПроцентСоответствияАлфавиту(ДанныеТекста, Кодировка.Значение);
		Если СоответствиеКодировки > 0.95 Тогда
			Возврат Кодировка.Значение;
		КонецЕсли;
		
		Если СоответствиеКодировки > МаксимальноеСоответствиеКодировки Тогда
			СоответствующаяКодировка = Кодировка.Значение;
			МаксимальноеСоответствиеКодировки = СоответствиеКодировки;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СоответствующаяКодировка;
	
КонецФункции

Функция ПроцентСоответствияАлфавиту(ДвоичныеДанные, ПроверяемаяКодировка)
	
	// АПК:1036-выкл, АПК:163-выкл - алфавит не требует проверки орфографии.
	Алфавит = "АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя"
		+ "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"
		+ "1234567890 ";
	// АПК:1036-вкл, АПК:163-вкл
	
	ПотокАлфавита = Новый ПотокВПамяти();
	ЗаписьАлфавита = Новый ЗаписьДанных(ПотокАлфавита);
	ЗаписьАлфавита.ЗаписатьСтроку(Алфавит, ПроверяемаяКодировка);
	ЗаписьАлфавита.Закрыть();
	
	ДанныеАлфавита = ПотокАлфавита.ЗакрытьИПолучитьДвоичныеДанные();
	ЧтениеДанныхАлфавита = Новый ЧтениеДанных(ДанныеАлфавита);
	БуферАлфавитаВКодировке = ЧтениеДанныхАлфавита.ПрочитатьВБуферДвоичныхДанных();
	
	Индекс = 0;
	СимволыАлфавита = Новый Массив;
	Пока Индекс <= БуферАлфавитаВКодировке.Размер - 1 Цикл
		
		ТекущийСимвол = БуферАлфавитаВКодировке[Индекс];
		
		// Символы кириллицы в кодировке UTF-8 - двухбайтовые.
		Если ПроверяемаяКодировка = "utf-8"
			И (ТекущийСимвол = 208
			Или ТекущийСимвол = 209) Тогда
			
			Индекс = Индекс + 1;
			ТекущийСимвол = Формат(ТекущийСимвол, "ЧН=0; ЧГ=") + Формат(БуферАлфавитаВКодировке[Индекс], "ЧН=0; ЧГ=");
		КонецЕсли;
		
		Индекс = Индекс + 1;
		СимволыАлфавита.Добавить(ТекущийСимвол);
		
	КонецЦикла;
	
	ЧтениеДанныхТекста = Новый ЧтениеДанных(ДвоичныеДанные);
	БуферДанныхТекста = ЧтениеДанныхТекста.ПрочитатьВБуферДвоичныхДанных(?(ПроверяемаяКодировка = "utf-8", 200, 100));
	РазмерБуфераТекста = БуферДанныхТекста.Размер;
	КоличествоСимволов = РазмерБуфераТекста;
	
	Индекс = 0;
	КоличествоВхождений = 0;
	Пока Индекс <= РазмерБуфераТекста - 1 Цикл
		
		ТекущийСимвол = БуферДанныхТекста[Индекс];
		Если ПроверяемаяКодировка = "utf-8"
			И (ТекущийСимвол = 208
			Или ТекущийСимвол = 209) Тогда
			
			// Если последний байт в буфере является первым байтом двухбайтового символа, игнорируем его.
			Если Индекс = РазмерБуфераТекста - 1 Тогда
				Прервать;
			КонецЕсли;
			
			Индекс = Индекс + 1;
			КоличествоСимволов = КоличествоСимволов - 1;
			ТекущийСимвол = Формат(ТекущийСимвол, "ЧН=0; ЧГ=") + Формат(БуферДанныхТекста[Индекс], "ЧН=0; ЧГ=");
			
		КонецЕсли;
		
		Индекс = Индекс + 1;
		Если СимволыАлфавита.Найти(ТекущийСимвол) <> Неопределено Тогда
			КоличествоВхождений = КоличествоВхождений + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ?(КоличествоСимволов = 0, 100, КоличествоВхождений/КоличествоСимволов);
	
КонецФункции

#КонецОбласти

#КонецЕсли
