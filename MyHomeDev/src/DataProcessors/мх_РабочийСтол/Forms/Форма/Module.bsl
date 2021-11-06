#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если мх_СобытияФорм.ФормаБудетПереопределенаПриИзмененииИнтерфейса(ЭтотОбъект) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИспользоватьПланированиеБюджета = ПолучитьФункциональнуюОпцию("мх_ИспользоватьПланированиеБюджета");
	мх_СобытияФорм.ЗаполнитьКэшированныеЗначенияДляСвязиТиповДоходовРасходов(ЭтотОбъект);
	
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	УстановитьОформлениеДляМобильногоКлиента();
	
	Обработки.мх_РабочийСтол.ЗаполнитьТаблицуБлоков(ТаблицаБлоков);
	
	ИнициализироватьДанныеРабочегоСтола();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьРабочийСтол" Тогда
		ОбновитьОтображениеНаСервере();	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Расходы_ПериодНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	Оповещение = Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект);

	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = Объект.ПериодОтчета;
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура БалансБюджета_БалансНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыДанных = Новый Структура("ПериодОтчета", Объект.ПериодОтчета);
	//@skip-warning
	ПользовательскиеНастройки = мх_СКДВызовСервера.УстановитьНастройкиОтчета("мх_ПланированиеБюджета", ПараметрыДанных, Неопределено);

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);

	ОткрытьФорму("Отчет.мх_ПланированиеБюджета.Форма", ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображение(Команда)

	ОбновитьОтображениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Расходы_СуммаЗаПериодНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ПараметрыДанных = Новый Структура("ПериодОтчета", Объект.ПериодОтчета);
	//@skip-warning
	ПользовательскиеНастройки = мх_СКДВызовСервера.УстановитьНастройкиОтчета("мх_АнализРасходов", ПараметрыДанных, Неопределено);

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);

	ОткрытьФорму("Отчет.мх_АнализРасходов.Форма", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРасход(Команда)
	ОткрытьФормуДобавленияРасхода(Неопределено);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура ОстаткиКошельковНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТипЧисло = Новый ОписаниеТипов("Число");
	
	Префикс = "ОстаткиКошельков_Кошелек";
	НомерКошелька = СтрЗаменить(Элемент.Имя, Префикс, "");
	НомерКошелька = ТипЧисло.ПривестиЗначение(НомерКошелька);
	
	ДанныеКошелька = ОстаткиКошельков_ДанныеОстатков[НомерКошелька];
	
	ОткрытьФормуДобавленияРасхода(ДанныеКошелька.Кошелек);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Оформление

&НаСервере
Процедура УстановитьОформлениеДляМобильногоКлиента()
	
	Если НЕ ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;
	
	// включаем разделители контейнеров
	Элементы.ДекорацияРазделитель1.Видимость = Истина;
	Элементы.ДекорацияРазделитель2.Видимость = Истина;
	Элементы.ДекорацияРазделитель3.Видимость = Истина;
	
	// строки контейнеров группируем вертикально
	
	СтрокиКонтейнеров = Новый Массив;
	СтрокиКонтейнеров.Добавить("СтрокаКонтейнеров0");
	СтрокиКонтейнеров.Добавить("СтрокаКонтейнеров1");
	СтрокиКонтейнеров.Добавить("СтрокаКонтейнеров2");
	
	Контейнеры = Новый Массив;
	
	Для каждого Строка Из СтрокиКонтейнеров Цикл
		
		Элемент = Элементы[Строка];
		Элемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		
		Для каждого ПодчиненныйЭлемент Из Элемент.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
				Контейнеры.Добавить(ПодчиненныйЭлемент.Имя);
			КонецЕсли;
		КонецЦикла;
				
	КонецЦикла;
	
	// подчиненные элементы контейнеров растягиваем по горизонтали
	
	Для каждого ИмяКонтейнера Из Контейнеры Цикл
		
		Контейнер = Элементы[ИмяКонтейнера];
		
		Для каждого Группа Из Контейнер.ПодчиненныеЭлементы Цикл
			
			Группа.РастягиватьПоГоризонтали = Истина;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Кошельки

&НаСервере
Процедура ВывестиНаФормуОстаткиПоКошелькам()

	ГруппаРодитель = Элементы.ГруппаОстаткиКошельковОтступ;
	Шрифт = Новый Шрифт(, 10, Ложь, , , , );
	
	// Удалить лишние элементы, если требуется
	
	ВсегоЭлементов = 0;
	Для каждого Элемент Из ГруппаРодитель.ПодчиненныеЭлементы Цикл
		Если СтрНачинаетсяС(Элемент.Имя, "ОстаткиКошельков_Кошелек") Тогда
			ВсегоЭлементов = ВсегоЭлементов + 1;
		КонецЕсли;
	КонецЦикла;
	
	ВсегоКошельков = ОстаткиКошельков_ДанныеОстатков.Количество();
	
	Разница = ВсегоКошельков - ВсегоЭлементов;
	
	// Если кошельков больше, чем элементов, тогда
	// добавим недостающие
	Если Разница > 0 Тогда
		
		Для сч = ВсегоЭлементов по ВсегоКошельков - 1 Цикл
			
			ИмяЭлемента					 = "ОстаткиКошельков_Кошелек" + сч;
			ЭлементФормы				 = ЭтотОбъект.Элементы.Добавить(ИмяЭлемента, Тип("ПолеФормы"), ГруппаРодитель);
			ЭлементФормы.Гиперссылка	 = Истина;
			ЭлементФормы.ШрифтЗаголовка	 = Новый Шрифт(,12);
			ЭлементФормы.Шрифт			 = Шрифт;
			ЭлементФормы.ПутьКДанным	 = ИмяЭлемента;
			ЭлементФормы.УстановитьДействие("Нажатие", "ОстаткиКошельковНажатие");
			
		КонецЦикла;
		
	// Если кошельков меньше, то удалим лишние элементы
	ИначеЕсли Разница < 0 Тогда
		
		Пока ВсегоЭлементов > ВсегоКошельков Цикл
			
			ИмяЭлемента = "ОстаткиКошельков_Кошелек" + (ВсегоЭлементов - 1);
			Элемент = ЭтотОбъект.Элементы[ИмяЭлемента];
			ЭтотОбъект.Элементы.Удалить(Элемент);
			
			ВсегоЭлементов = ВсегоЭлементов - 1;
			
		КонецЦикла;
		
	КонецЕсли;
		
	
	Сч = 0;
	
	Для каждого ДанныеОстатка Из ОстаткиКошельков_ДанныеОстатков Цикл
		
		ИмяЭлемента = "ОстаткиКошельков_Кошелек" + сч;
		
		ПредставлениеСуммы = мх_РабочийСтол.ПредставлениеСуммы(ДанныеОстатка.Баланс, "", Истина);
		
		ЭтотОбъект[ИмяЭлемента] = ПредставлениеСуммы;
		
		ЭлементФормы				 = ЭтотОбъект.Элементы[ИмяЭлемента];		
		ЭлементФормы.Заголовок		 = Строка(ДанныеОстатка.Кошелек);
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВыборПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПериодОтчета = Результат;
	
	ОбновитьОтображениеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанныеРабочегоСтола()
	
	КлючОбъекта = "Обработка.мх_РабочийСтол.Форма.Форма/ТекущиеДанные";
	
	Настройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта);
	
	Если Настройки = Неопределено Тогда
		Настройки = Новый Соответствие;
		Настройки.Вставить("Объект.ПериодОтчета", Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотМесяц));
		ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта,,Настройки);
	КонецЕсли;
	
	Объект.ПериодОтчета = Настройки.Получить("Объект.ПериодОтчета");
	
	ПрочитатьДанныеБлоков();
	
	ВывестиНаФормуДанныеТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДобавленияРасхода(Кошелек)
	
	ПараметрыФормы = Новый Структура("Кошелек", Кошелек);
	
	ОткрытьФорму("Обработка.мх_РабочийСтол.Форма.ДобавлениеРасхода", ПараметрыФормы, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеНаСервере()
	
	ПрочитатьДанныеБлоков();
	
	ВывестиНаФормуДанныеТаблиц();
	
КонецПроцедуры

Процедура ВывестиНаФормуПланируемыеРасходы()
	
	ШаблонИмениЭлемента = "ПланируемыеРасходы_Расход";
		
	КоличествоВыводимыхРасходов = 7;
	
	// Скроем все элементы, и будет показывать, если есть данные
	Для сч = 0 По КоличествоВыводимыхРасходов - 1 Цикл
		
		ИмяЭлемента = ШаблонИмениЭлемента + Сч;
		Элементы[ИмяЭлемента].Видимость = Ложь;
		
	КонецЦикла;
	
	Сч = 0;
	
	Для каждого СтрокаРасхода Из ПланируемыеРасходы_ДанныеРасходов Цикл
		
		ИмяЭлемента = ШаблонИмениЭлемента + Сч;
		
		Если Сч >= КоличествоВыводимыхРасходов - 1 Тогда
			Прервать;
		КонецЕсли;
		
		Если СтрокаРасхода.СуммаРасходПлан <= СтрокаРасхода.СуммаРасходФакт Тогда
			Продолжить;
		КонецЕсли;
		
		ДатаРасхода = Формат(СтрокаРасхода.ДатаРасхода, "ДФ='dd MMM';");
		СтатьяРасходаСтрокой = ОтформатироватьСтатьюРасхода(СтрокаРасхода.СтатьяРасходов);
		
		ЭлементФормы				 = ЭтотОбъект.Элементы[ИмяЭлемента];
		ЭлементФормы.Заголовок		 = СтатьяРасходаСтрокой;
		ЭлементФормы.Видимость		 = Истина;
		
		СуммаРасхода = СтрокаРасхода.СуммаРасходПлан - СтрокаРасхода.СуммаРасходФакт;
		СуммаРасхода = мх_РабочийСтол.ПредставлениеСуммы(СуммаРасхода, " руб.", Истина);
		ОтформатироватьСумму(СуммаРасхода);
		
		ДанныеРасхода = Новый ФорматированнаяСтрока(ДатаРасхода, " ",СуммаРасхода);
		ЭтотОбъект[ИмяЭлемента] = ДанныеРасхода;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтформатироватьСумму(СуммаРасхода)
	
	МаксимальнаяДлинаСуммы = 13;
	ДлинаСуммы = СтрДлина(СуммаРасхода);
	
	Разность = МаксимальнаяДлинаСуммы - ДлинаСуммы;
	Дополнение = "";
	
	Пока Разность > 0 Цикл
		
		Дополнение = "0" + Дополнение;
		Разность = Разность - 1;
		
	КонецЦикла;
	
	Цвет = ЦветаСтиля.мх_ЦветФонаГруппыИндикатора;
	Дополнение = Новый ФорматированнаяСтрока(Дополнение, , Цвет, , );
	
	СуммаРасхода = Новый ФорматированнаяСтрока(Дополнение, СуммаРасхода);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОтформатироватьСтатьюРасхода(СтатьяРасхода)
	
	СтатьяРасходаСтрокой = Строка(СтатьяРасхода);
	МаксимальнаяДлинаСтатьиРасхода = 17;
	
	ТекущаяДлина = СтрДлина(СтатьяРасходаСтрокой);
	
	Если ТекущаяДлина > МаксимальнаяДлинаСтатьиРасхода Тогда
		СтатьяРасходаСтрокой = Лев(СтатьяРасходаСтрокой, МаксимальнаяДлинаСтатьиРасхода) + "...";
	КонецЕсли;
	
	Возврат СтатьяРасходаСтрокой;
	
КонецФункции

&НаСервере
Процедура ВывестиНаФормуДанныеТаблиц()
	
	ВывестиНаФормуОстаткиПоКошелькам();
	ВывестиНаФормуПланируемыеРасходы();
	
КонецПроцедуры

#Область Блоки

Процедура ПрочитатьДанныеБлоков()
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("УникальныйИдентификатор",          УникальныйИдентификатор);
	СтруктураПараметров.Вставить("АдресХранилища",                   АдресХранилища);
	СтруктураПараметров.Вставить("ПериодОтчета",                     Объект.ПериодОтчета);
	
	ПараметрыПроцедуры = Новый Массив();
	ПараметрыПроцедуры.Добавить(СтруктураПараметров);
	
	ИменаТаблиц = Новый Массив;
	ИменаТаблиц.Добавить("ПланируемыеРасходы_ДанныеРасходов");
	ИменаТаблиц.Добавить("ОстаткиКошельков_ДанныеОстатков");

	Для Каждого Блок Из ТаблицаБлоков Цикл
		
//		Если Не Блок.Пометка Тогда
//			Продолжить;
//		КонецЕсли;
		
		Если Не ПустаяСтрока(Блок.ПроцедураПолученияДанных) Тогда
			
			ОбщегоНазначения.ВыполнитьМетодКонфигурации(Блок.ПроцедураПолученияДанных, ПараметрыПроцедуры);
			
			ДанныеБлока = ПолучитьИзВременногоХранилища(АдресХранилища);
			
			ЗаполнитьДанныеБлока(ДанныеБлока, ИменаТаблиц);
			
		КонецЕсли;
		
	КонецЦикла;	
		
	Если ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		УдалитьИзВременногоХранилища(АдресХранилища);
		АдресХранилища = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеБлока(ДанныеБлока, ИменаТаблиц)
	
	Если ТипЗнч(ДанныеБлока) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СписокИсключений = Новый Массив;
	
	Для каждого ИмяТаблицы Из ИменаТаблиц Цикл
		
		ТаблицаДанных = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеБлока, ИмяТаблицы, Неопределено);
		
		Если ТаблицаДанных <> Неопределено Тогда
			СписокИсключений.Добавить(ИмяТаблицы);
			ЭтотОбъект[ИмяТаблицы].Загрузить(ТаблицаДанных);
		КонецЕсли;
		
	КонецЦикла;
	
	ИсключаемыеСвойства = СтрСоединить(СписокИсключений);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеБлока,,ИсключаемыеСвойства);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти