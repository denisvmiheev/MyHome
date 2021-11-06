///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик подключенной команды.
//
// Параметры:
//   МассивСсылок - Массив из ЛюбаяСсылка - ссылки выбранных объектов, для которых выполняется команда.
//   ПараметрыВыполнения - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды
//
Процедура ОбработчикКоманды(Знач МассивСсылок, Знач ПараметрыВыполнения) Экспорт
	ПараметрыВыполнения.Вставить("ОбъектыПечати", МассивСсылок);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыВыполнения.ОписаниеКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры, Истина);
	ВыполнитьПодключаемуюКомандуПечатиЗавершение(Истина, ПараметрыВыполнения);
КонецПроцедуры

// Формирует табличный документ в форме подсистемы "Печать".
Процедура ВыполнитьОткрытиеПечатнойФормы(ИсточникДанных, ИдентификаторКоманды, ОбъектыНазначения, Форма, СтандартнаяОбработка) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Форма",                Форма);
	Параметры.Вставить("ИсточникДанных",       ИсточникДанных);
	Параметры.Вставить("ИдентификаторКоманды", ИдентификаторКоманды);
	Если СтандартнаяОбработка Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОткрытиеПечатнойФормыЗавершение", ЭтотОбъект, Параметры);
		УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов(ОписаниеОповещения, ОбъектыНазначения, Форма);
	Иначе
		ВыполнитьОткрытиеПечатнойФормыЗавершение(ОбъектыНазначения, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму настроек видимости команд в подменю "Печать".
Процедура ОткрытьФормуНастроекПодменюПечать(Отбор) Экспорт
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	ОткрытьФорму("ОбщаяФорма.НастройкаКомандПечати", ПараметрыОткрытия, , , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

// Открыть форму для выбора вариантов формата вложений
//
// Параметры:
//  НастройкиФормата - Структура:
//       * УпаковатьВАрхив   - Булево - признак необходимости упаковки вложений в архив.
//       * ФорматыСохранения - Массив - список выбранных форматов вложений.
//  Оповещение       - ОписаниеОповещения - оповещение, которое вызывается после закрытие формы для обработки
//                                          результатов выбора.
//
Процедура ОткрытьФормуВыбораФорматаВложений(НастройкиФормата, Оповещение) Экспорт
	ПараметрыФормы = Новый Структура("НастройкиФормата", НастройкиФормата);
	ОткрытьФорму("ОбщаяФорма.ВыборФорматаВложений", ПараметрыФормы,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПодключаемуюКомандуПечатиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры)
	
	Если Не РасширениеРаботыСФайламиПодключено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	ОбъектыПечати = ДополнительныеПараметры.ОбъектыПечати;
	
	ОписаниеКоманды = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ОписаниеКоманды);
	ОписаниеКоманды.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		
		ИмяПоказателя = НСтр("ru = 'Печать'") + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/%1/%2/%3/%4/%5/%6/%7",
			ОписаниеКоманды.Идентификатор,
			ОписаниеКоманды.МенеджерПечати,
			ОписаниеКоманды.Обработчик,
			Формат(ОписаниеКоманды.ОбъектыПечати.Количество(), "ЧГ=0"),
			?(ОписаниеКоманды.СразуНаПринтер, "Принтер", ""),
			ОписаниеКоманды.ФорматСохранения,
			?(ОписаниеКоманды.ФиксированныйКомплект, "Фиксированный", ""));
		
		МодульОценкаПроизводительностиКлиент.НачатьЗамерВремениТехнологический(Истина, НРег(ИмяПоказателя));
	КонецЕсли;
	
	Если ОписаниеКоманды.МенеджерПечати = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" 
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиент");
			МодульДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуПечати(ОписаниеКоманды, Форма);
			Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ОписаниеКоманды.Обработчик) Тогда
		ОписаниеКоманды.Вставить("Форма", Форма);
		ИмяОбработчика = ОписаниеКоманды.Обработчик;
		Если СтрЧислоВхождений(ИмяОбработчика, ".") = 0 И ЭтоОтчетИлиОбработка(ОписаниеКоманды.МенеджерПечати) Тогда
			ОсновнаяФорма = ПолучитьФорму(ОписаниеКоманды.МенеджерПечати + ".Форма", , Форма, Истина); // АПК:
			ИмяОбработчика = "ОсновнаяФорма." + ИмяОбработчика;
		КонецЕсли;
		Обработчик = ИмяОбработчика + "(ОписаниеКоманды)";
		Результат = Вычислить(Обработчик);
		Возврат;
	КонецЕсли;
	
	Если ОписаниеКоманды.СразуНаПринтер Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
			ОбъектыПечати, ОписаниеКоманды.ДополнительныеПараметры);
	Иначе
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
			ОбъектыПечати, Форма, ОписаниеКоманды);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПроведенностьДокументовДиалогПроведения(Параметры) Экспорт
	
	Если УправлениеПечатьюВызовСервера.ДоступноПравоПроведения(Параметры.НепроведенныеДокументы) Тогда
		Если Параметры.НепроведенныеДокументы.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документ, его необходимо предварительно провести. Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документы, их необходимо предварительно провести. Выполнить проведение документов и продолжить?'");
		КонецЕсли;
	Иначе
		Если Параметры.НепроведенныеДокументы.Количество() = 1 Тогда
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать документ, его необходимо предварительно провести. Недостаточно прав для проведения документа, печать невозможна.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать документы, их необходимо предварительно провести. Недостаточно прав для проведения документов, печать невозможна.'");
		КонецЕсли;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПроведенностьДокументовПроведениеДокументов", ЭтотОбъект, Параметры);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ПроверитьПроведенностьДокументовПроведениеДокументов(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДополнительныеПараметры.НепроведенныеДокументы);
	
	ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2'");
	НепроведенныеДокументы = Новый Массив;
	Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(ИнформацияОДокументе.Ссылка), ИнформацияОДокументе.ОписаниеОшибки),
			ИнформацияОДокументе.Ссылка);
		НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
	КонецЦикла;
	ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДополнительныеПараметры.СписокДокументов, НепроведенныеДокументы);
	ИзмененныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДополнительныеПараметры.НепроведенныеДокументы, НепроведенныеДокументы);
	
	ДополнительныеПараметры.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
	ДополнительныеПараметры.Вставить("ПроведенныеДокументы", ПроведенныеДокументы);
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъектов(ИзмененныеДокументы);
	
	// Если команда была вызвана из формы, то зачитываем в форму актуальную (проведенную) копию из базы.
	Если ТипЗнч(ДополнительныеПараметры.Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
		Попытка
			ДополнительныеПараметры.Форма.Прочитать();
		Исключение
			// Если метода Прочитать нет, значит печать выполнена не из формы объекта.
		КонецПопытки;
	КонецЕсли;
		
	Если НепроведенныеДокументы.Количество() > 0 Тогда
		// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов.
		ТекстДиалога = НСтр("ru = 'Не удалось провести один или несколько документов.'");
		
		КнопкиДиалога = Новый СписокЗначений;
		Если ПроведенныеДокументы.Количество() > 0 Тогда
			ТекстДиалога = ТекстДиалога + " " + НСтр("ru = 'Продолжить?'");
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
		Иначе
			КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПроведенностьДокументовЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстДиалога, КнопкиДиалога);
		Возврат;
	КонецЕсли;
	
	ПроверитьПроведенностьДокументовЗавершение(Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПроверитьПроведенностьДокументовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> Неопределено И РезультатВопроса <> КодВозвратаДиалога.Пропустить Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеПроцедурыЗавершения, ДополнительныеПараметры.ПроведенныеДокументы);
	
КонецПроцедуры

Функция ЭтоОтчетИлиОбработка(МенеджерПечати)
	Если Не ЗначениеЗаполнено(МенеджерПечати) Тогда
		Возврат Ложь;
	КонецЕсли;
	МассивПодстрок = СтрРазделить(МенеджерПечати, ".");
	Если МассивПодстрок.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	Вид = ВРег(СокрЛП(МассивПодстрок[0]));
	Возврат Вид = "ОТЧЕТ" Или Вид = "ОБРАБОТКА";
КонецФункции

Процедура ВыполнитьОткрытиеПечатнойФормыЗавершение(ОбъектыНазначения, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ИдентификаторКоманды", ДополнительныеПараметры.ИдентификаторКоманды);
	ПараметрыИсточника.Вставить("ОбъектыНазначения",    ОбъектыНазначения);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИсточникДанных",     ДополнительныеПараметры.ИсточникДанных);
	ПараметрыОткрытия.Вставить("ПараметрыИсточника", ПараметрыИсточника);
	ПараметрыОткрытия.Вставить("ПараметрКоманды", ОбъектыНазначения);
	
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, Форма);
	
КонецПроцедуры

// Синхронный аналог ОбщегоНазначенияКлиент.СоздатьВременныйКаталог для обратной совместимости.
//
Функция СоздатьВременныйКаталог(Знач Расширение = "") Экспорт 
	
	ИмяКаталога = КаталогВременныхФайлов() + "v8_" + Строка(Новый УникальныйИдентификатор);
	Если Не ПустаяСтрока(Расширение) Тогда 
		ИмяКаталога = ИмяКаталога + "." + Расширение;
	КонецЕсли;
	СоздатьКаталог(ИмяКаталога);
	Возврат ИмяКаталога;
	
КонецФункции

#КонецОбласти
