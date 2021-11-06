///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыЗаписиПередЗаписьюПродолжение;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", Объект.Роли);
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы", ЗначениеЗаполнено(Объект.Ссылка));
	
	// Подготовка вспомогательных данных.
	УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений(ЭтотОбъект, Истина);
	
	// Установка постоянной доступности свойств.
	
	// Определение необходимости настройки ограничений доступа.
	Если Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		Элементы.ВидыИЗначенияДоступа.Видимость = Ложь;
	КонецЕсли;
	
	// Определение возможности редактирования элементов формы (перезапись доступна).
	БезРедактированияПоставляемыхЗначений = ТолькоПросмотр
		Или Не Объект.Ссылка.Пустая()
		  И Справочники.ПрофилиГруппДоступа.ЗапретИзмененияПрофиля(Объект, Элементы.Родитель.ТолькоПросмотр);
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	Если Объект.Ссылка = УправлениеДоступом.ПрофильАдминистратор()
	   И Не Пользователи.ЭтоПолноправныйПользователь(, Не РазделениеВключено) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.Наименование.ТолькоПросмотр = БезРедактированияПоставляемыхЗначений;
	
	// Настройка редактирования видов доступа.
	Элементы.ВидыДоступа.ТолькоПросмотр     = БезРедактированияПоставляемыхЗначений;
	Элементы.ЗначенияДоступа.ТолькоПросмотр = БезРедактированияПоставляемыхЗначений;
	Элементы.ВыбратьНазначение.Доступность = Не БезРедактированияПоставляемыхЗначений;
	
	ОбработатьИнтерфейсРолей("УстановитьТолькоПросмотрРолей", БезРедактированияПоставляемыхЗначений);
	
	УстановитьДоступностьОписанияИВосстановленияПоставляемогоПрофиля();
	
	ВыполненаПроцедураПриСозданииНаСервере = Истина;
	
	ПользователиСлужебный.ОбновитьНазначениеПриСозданииНаСервере(ЭтотОбъект);
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ФормаЗаписатьИЗакрыть.Доступность = Не ТолькоПросмотр
		И ПравоДоступа("Редактирование", Метаданные.Справочники.ПрофилиГруппДоступа);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если НЕ ВыполненаПроцедураПриСозданииНаСервере Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", Объект.Роли);
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЧтенииНаСервере", Истина);
	
	УправлениеДоступомСлужебный.ПриПовторномЧтенииНаСервереФормыРедактированияРазрешенныхЗначений(
		ЭтотОбъект, ТекущийОбъект);
	
	УстановитьДоступностьОписанияИВосстановленияПоставляемогоПрофиля(ТекущийОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ТребуетсяПроверитьЗаполнениеПрофиля = НЕ ПараметрыЗаписи.Свойство(
		"ОтветПоОбновлениюГруппДоступаПрофиляПолучен");
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
	   И ТребуетсяОбновитьГруппыДоступаПрофиля
	   И НЕ ПараметрыЗаписи.Свойство("ОтветПоОбновлениюГруппДоступаПрофиляПолучен") Тогда
		
		Отказ = Истина;
		ПараметрыЗаписиПередЗаписьюПродолжение = ПараметрыЗаписи;
		ПодключитьОбработчикОжидания("ПередЗаписьюПродолжениеОбработчикОжидания", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Заполнение ролей объекта из коллекции.
	ТекущийОбъект.Роли.Очистить();
	Для каждого Строка Из КоллекцияРолей Цикл
		ТекущийОбъект.Роли.Добавить().Роль = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			"Роль." + Строка.Роль);
	КонецЦикла;
	
	Если ПараметрыЗаписи.Свойство("ОбновитьГруппыДоступаПрофиля") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ОбновитьГруппыДоступаПрофиля");
	КонецЕсли;
	
	УправлениеДоступомСлужебный.ПередЗаписьюНаСервереФормыРедактированияРазрешенныхЗначений(
		ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДополнительныеСвойства.Свойство(
	         "ПерсональныеГруппыДоступаСОбновленнымНаименованием") Тогда
		
		ПараметрыЗаписи.Вставить(
			"ПерсональныеГруппыДоступаСОбновленнымНаименованием",
			ТекущийОбъект.ДополнительныеСвойства.ПерсональныеГруппыДоступаСОбновленнымНаименованием);
	КонецЕсли;
	
	УправлениеДоступомСлужебный.ПослеЗаписиНаСервереФормыРедактированияРазрешенныхЗначений(
		ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	УстановитьДоступностьОписанияИВосстановленияПоставляемогоПрофиля(ТекущийОбъект);
	
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбъектЗаписывался = Истина;
	ТребуетсяОбновитьГруппыДоступаПрофиля = Ложь;
	
	Оповестить("Запись_ПрофилиГруппДоступа", Новый Структура, Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ПерсональныеГруппыДоступаСОбновленнымНаименованием") Тогда
		ОповеститьОбИзменении(Тип("СправочникСсылка.ГруппыДоступа"));
		
		Для каждого ПерсональнаяГруппаДоступа Из ПараметрыЗаписи.ПерсональныеГруппыДоступаСОбновленнымНаименованием Цикл
			Оповестить("Запись_ГруппыДоступа", Новый Структура, ПерсональнаяГруппаДоступа);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ТребуетсяПроверитьЗаполнениеПрофиля Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Ошибки = Неопределено;
	
	// Проверка наличия ролей в метаданных.
	ПроверенныеРеквизитыОбъекта.Добавить("Роли.Роль");
	Если Не Элементы.Роли.ТолькоПросмотр Тогда
		ЭлементыДерева = Роли.ПолучитьЭлементы();
		Для Каждого Строка Из ЭлементыДерева Цикл
			Если Не Строка.Пометка Тогда
				Продолжить;
			КонецЕсли;
			Если Строка.ЭтоНесуществующаяРоль Тогда
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					"Роли[%1].РолиСиноним",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль ""%1"" не найдена в метаданных.'"), Строка.Синоним),
					"Роли",
					ЭлементыДерева.Индекс(Строка),
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль ""%1"" в строке %2 не найдена в метаданных.'"), Строка.Синоним, "%1"));
			КонецЕсли;
			Если Строка.ЭтоНедоступнаяРоль Тогда
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					"Роли[%1].РолиСиноним",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль ""%1"" недоступна для назначения профиля.'"), Строка.Синоним),
					"Роли",
					ЭлементыДерева.Индекс(Строка),
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль ""%1"" в строке %2 недоступна для назначения профиля.'"), Строка.Синоним, "%1"));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся видов и значений доступа.
	УправлениеДоступомСлужебныйКлиентСервер.ОбработкаПроверкиЗаполненияНаСервереФормыРедактированияРазрешенныхЗначений(
		ЭтотОбъект, Отказ, ПроверенныеРеквизитыОбъекта, Ошибки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Объект"));
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ПроверенныеРеквизитыОбъекта",
		ПроверенныеРеквизитыОбъекта);
	
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыДоступа

&НаКлиенте
Процедура ВидыДоступаПриИзменении(Элемент)
	
	ТребуетсяОбновитьГруппыДоступаПрофиля = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриАктивизацииСтроки(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриАктивизацииСтроки(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПередНачаломДобавления(
		ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПередУдалением(Элемент, Отказ)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПередУдалением(
		ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриНачалеРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элемента ВидДоступаПредставление таблицы формы ВидыДоступа.

&НаКлиенте
Процедура ВидыДоступаВидДоступаПредставлениеПриИзменении(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаВидДоступаПредставлениеПриИзменении(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаВидДоступаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаВидДоступаПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элемента ВсеРазрешеныПредставление таблицы формы ВидыДоступа.

&НаКлиенте
Процедура ВидыДоступаВсеРазрешеныПредставлениеПриИзменении(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаВсеРазрешеныПредставлениеПриИзменении(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаВсеРазрешеныПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаВсеРазрешеныПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначенияДоступа

&НаКлиенте
Процедура ЗначенияДоступаПриИзменении(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ЗначенияДоступаПриИзменении(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияДоступаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеДоступомСлужебныйКлиент.ЗначенияДоступаПриНачалеРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияДоступаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДоступомСлужебныйКлиент.ЗначенияДоступаПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаОчистка(Элемент, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаОчистка(
		ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаАвтоПодбор(
		ЭтотОбъект, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаОкончаниеВводаТекста(
		ЭтотОбъект, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРоли

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаКлиенте
Процедура РолиПометкаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.Роли.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаТаблицы.Пометка И СтрокаТаблицы.Имя = "ИнтерактивноеОткрытиеВнешнихОтчетовИОбработок" Тогда
		Оповещение = Новый ОписаниеОповещения("РолиПометкаПриИзмененииПослеПодтверждения", ЭтотОбъект);
		ПараметрыФормы = Новый Структура("Ключ", "ПередВыборомРоли");
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", ПараметрыФормы, , , , , Оповещение);
	Иначе
		ОбработатьИнтерфейсРолей("ОбновитьСоставРолей");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РолиПометкаПриИзмененииПослеПодтверждения(Ответ, ПараметрыВыполнения) Экспорт
	СтрокаТаблицы = Элементы.Роли.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Ответ = "Продолжить" Тогда
		ОбработатьИнтерфейсРолей("ОбновитьСоставРолей");
	Иначе
		СтрокаТаблицы.Пометка = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПоНачальномуЗаполнению(Команда)
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ВосстановитьПоНачальномуЗаполнениюПродолжение", ЭтотОбъект),
		НСтр("ru = 'Восстановить профиль по содержимому начального заполнения?'"),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНеИспользуемыеВидыДоступа(Команда)
	
	ПоказыватьНеИспользуемыеВидыДоступаНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ТолькоВыбранныеРоли");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ВключитьВсе");
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ИсключитьВсе");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНазначение(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект);
	ПользователиСлужебныйКлиент.ВыбратьНазначение(ЭтотОбъект, НСтр("ru = 'Выбор назначения профиля групп доступа'"),,, ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение обработчика события ПередЗаписью.
&НаКлиенте
Процедура ПередЗаписьюПродолжениеОбработчикОжидания()
	
	ПараметрыЗаписи = ПараметрыЗаписиПередЗаписьюПродолжение;
	ПараметрыЗаписиПередЗаписьюПродолжение = Неопределено;
	
	Если ПроверитьЗаполнение() Тогда
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗаписьюПродолжение", ЭтотОбъект, ПараметрыЗаписи),
			ТекстВопросаОбновитьГруппыДоступаПрофиля(),
			РежимДиалогаВопрос.ДаНетОтмена,
			,
			КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение обработчика события ПередЗаписью.
&НаКлиенте
Процедура ПередЗаписьюПродолжение(Ответ, ПараметрыЗаписи) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыЗаписи.Вставить("ОбновитьГруппыДоступаПрофиля");
	КонецЕсли;
	
	ПараметрыЗаписи.Вставить("ОтветПоОбновлениюГруппДоступаПрофиляПолучен");
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Продолжение обработчика команды ВосстановитьПоНачальномуЗаполнению.
&НаКлиенте
Процедура ВосстановитьПоНачальномуЗаполнениюПродолжение(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ВосстановитьПоНачальномуЗаполнениюЗавершение", ЭтотОбъект),
		ТекстВопросаОбновитьГруппыДоступаПрофиля(),
		РежимДиалогаВопрос.ДаНетОтмена,
		,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// Продолжение обработчика команды ВосстановитьПоНачальномуЗаполнению.
&НаКлиенте
Процедура ВосстановитьПоНачальномуЗаполнениюЗавершение(Ответ, Контекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность ИЛИ ОбъектЗаписывался Тогда
		РазблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ОбновитьГруппыДоступа = (Ответ = КодВозвратаДиалога.Да);
	
	ГруппыДоступаПрофиля = Неопределено;
	НачальноеЗаполнениеПрофиляГруппДоступа(ОбновитьГруппыДоступа, ГруппыДоступаПрофиля);
	
	Прочитать();
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
	Если ОбновитьГруппыДоступа Тогда
		Текст =
			НСтр("ru = 'Профиль ""%1"" восстановлен по содержимому начального заполнения,
			           |группы доступа профиля обновлены.'");
	Иначе
		Текст =
			НСтр("ru = 'Профиль ""%1"" восстановлен по содержимому начального заполнения,
			           |группы доступа профиля не обновлены.'");
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Профиль восстановлен'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, Объект.Наименование));
	
	Оповестить("Запись_ПрофилиГруппДоступа", Новый Структура, Объект.Ссылка);
	
	Если ОбновитьГруппыДоступа Тогда
		ОповеститьОбИзменении(Тип("СправочникСсылка.ГруппыДоступа"));
		
		Для каждого ГруппаДоступаПрофиля Из ГруппыДоступаПрофиля Цикл
			Оповестить("Запись_ГруппыДоступа", Новый Структура, ГруппаДоступаПрофиля);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьНеИспользуемыеВидыДоступаНаСервере()
	
	УправлениеДоступомСлужебный.ОбновитьОтображениеНеиспользуемыхВидовДоступа(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьОписанияИВосстановленияПоставляемогоПрофиля(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	Если Справочники.ПрофилиГруппДоступа.ЕстьНачальноеЗаполнениеПрофиля(ТекущийОбъект.Ссылка) Тогда
		
		ОписаниеПоставляемогоПрофиля =
			Справочники.ПрофилиГруппДоступа.ПояснениеПоставляемогоПрофиля(ТекущийОбъект.Ссылка);
		
		Если Справочники.ПрофилиГруппДоступа.ПоставляемыйПрофильИзменен(ТекущийОбъект) Тогда
			// Определение прав восстановления по начальному заполнению.
			Элементы.ВосстановитьПоНачальномуЗаполнению.Видимость =
				Пользователи.ЭтоПолноправныйПользователь(,, Ложь);
			
			Элементы.ПоставляемыйПрофильИзменен.Видимость = Истина;
		Иначе
			Элементы.ВосстановитьПоНачальномуЗаполнению.Видимость = Ложь;
			Элементы.ПоставляемыйПрофильИзменен.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.Комментарий2.Видимость = Ложь;
	Иначе
		Элементы.ВосстановитьПоНачальномуЗаполнению.Видимость = Ложь;
		Элементы.ОписаниеПоставляемогоПрофиля.Видимость = Ложь;
		Элементы.ПоставляемыйПрофильИзменен.Видимость = Ложь;
		Элементы.Комментарий1.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ТекстВопросаОбновитьГруппыДоступаПрофиля()
	
	Возврат
		НСтр("ru = 'Обновить группы доступа, использующие этот профиль?
		           |
		           |Будут удалены лишние виды доступа с заданными для них
		           |значениями доступа и добавлены недостающие виды доступа.'");
		
КонецФункции

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр", ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",            ЭтотОбъект);
	ПараметрыДействия.Вставить("КоллекцияРолей",   КоллекцияРолей);
	
	ПараметрыДействия.Вставить("СкрытьРольПолныеПрава",
		Объект.Ссылка <> УправлениеДоступом.ПрофильАдминистратор());
	
	ПараметрыДействия.Вставить("НазначениеРолей",
		УправлениеДоступомСлужебныйКлиентСервер.НазначениеПрофиля(Объект));
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура НачальноеЗаполнениеПрофиляГруппДоступа(Знач ОбновитьГруппыДоступа, ГруппыДоступаПрофиля)
	
	Справочники.ПрофилиГруппДоступа.ЗаполнитьПоставляемыйПрофиль(
		Объект.Ссылка, ОбновитьГруппыДоступа);
	
	Если Не ОбновитьГруппыДоступа Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профиль", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль = &Профиль";
	
	ГруппыДоступаПрофиля = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНазначения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
		ОбработатьИнтерфейсРолей("ОбновитьДеревоРолей");
		ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
