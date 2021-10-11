#Область ПрограммныйИнтерфейс

Функция ВыполнитьОбработкуАвтоплатежа(Автоплатеж) Экспорт

	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");

	Реквизиты = "ВидПлатежа,Сумма,СтатьяДоходовРасходов,Кошелек,АналитикаДоходов,АналитикаРасходов";
	РеквизитыПлатежа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Автоплатеж, Реквизиты);

	Если РеквизитыПлатежа.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыДвиженийДенежныхСредств.Расход") Тогда
		Результат = СоздатьРасход(РеквизитыПлатежа);
	ИначеЕсли РеквизитыПлатежа.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыДвиженийДенежныхСредств.Доход") Тогда
		Результат = СоздатьДоход(РеквизитыПлатежа);
	Иначе
		ВызватьИсключение НСтр("ru = 'Необрабатываемый формат платежа'");
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРасписаниеАвтоплатежа(Знач ИдентификаторРегламентногоЗадания) Экспорт

	Результат = Новый Структура("Расписание, Использование", Новый РасписаниеРегламентногоЗадания, Ложь);

	Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("УникальныйИдентификатор", ИдентификаторРегламентногоЗадания);
		Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.мх_ОбработкаАвтоплатежей);
		МассивЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
		Если МассивЗаданий.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Результат, МассивЗаданий[0], "Расписание, Использование");
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Процедура УстановитьРасписаниеАвтоплатежа(Знач АвтоплатежОбъект, Расписание, Использование) Экспорт

	Автоплатеж = АвтоплатежОбъект.Ссылка;

	Если ДополнительныеОтчетыИОбработкиКлиентСервер.РасписаниеЗадано(Расписание) Тогда

		Если ЗначениеЗаполнено(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания) Тогда
			Задание = РегламентныеЗаданияСервер.Задание(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания);
		КонецЕсли;

		Если Задание = Неопределено Тогда

			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.мх_ОбработкаАвтоплатежей);

			Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
			АвтоплатежОбъект.ИдентификаторРегламентногоЗадания = Задание.УникальныйИдентификатор;

		КонецЕсли;

		ИзменениеЗадания = Новый Структура;
		ИзменениеЗадания.Вставить("Расписание", Расписание);
		ИзменениеЗадания.Вставить("Наименование", Лев(ПредставлениеЗадания(Строка(Автоплатеж)), 120));
		ИзменениеЗадания.Вставить("Использование", Использование);
		
		//TODO Добавить возможность указывать пользователя в рег. задании автоплатежа	
		//Если Не ПустаяСтрока(ТипОчередиОбъект.ИмяПользователя) Тогда 
		//	ИзменениеЗадания.Вставить("ИмяПользователя", ТипОчередиОбъект.ИмяПользователя);
		//КонецЕсли;

		ПараметрыПроцедуры = Новый Массив;
		ПараметрыПроцедуры.Добавить(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания);
		ИзменениеЗадания.Вставить("Параметры", ПараметрыПроцедуры);

		РегламентныеЗаданияСервер.ИзменитьЗадание(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания, ИзменениеЗадания);

	Иначе

		Если ЗначениеЗаполнено(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания) Тогда

			Задание = РегламентныеЗаданияСервер.Задание(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания);
			Если Задание <> Неопределено Тогда
				РегламентныеЗаданияСервер.УдалитьЗадание(АвтоплатежОбъект.ИдентификаторРегламентногоЗадания);
			КонецЕсли;

			АвтоплатежОбъект.ИдентификаторРегламентногоЗадания = Неопределено;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Функция ПредставлениеЗадания(НаименованиеПлатежа)
	Возврат "Автоплатеж: " + СокрЛП(НаименованиеПлатежа);
КонецФункции

Процедура ВыполнитьОбработкуАвтоплатежей(ИдентификаторыПлатежей) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторыПлатежей", ИдентификаторыПлатежей);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Автоплатежи.Ссылка,
	|	Автоплатежи.ПометкаУдаления,
	|	Автоплатежи.Используется
	|ИЗ
	|	Справочник.мх_Автоплатежи КАК Автоплатежи
	|ГДЕ
	|	Автоплатежи.ИдентификаторРегламентногоЗадания В (&ИдентификаторыПлатежей)";

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда

		Если Не Выборка.Используется Или Выборка.ПометкаУдаления Тогда
			ВызватьИсключение НСтр("ru = 'Автоплатеж не используется'");
		КонецЕсли;

		Результат = ВыполнитьОбработкуАвтоплатежа(Выборка.Ссылка);

		Если Не Результат.Успех Тогда
			ВызватьИсключение Результат.ОписаниеОшибки;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Функция СоздатьРасход(Знач РеквизитыПлатежа)

	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");

	ПараметрыРасхода = РеквизитыПлатежа;
	ПараметрыРасхода.Вставить("СтатьяРасходов", РеквизитыПлатежа.СтатьяДоходовРасходов);
	ПараметрыРасхода.Вставить("АналитикаРасходов", РеквизитыПлатежа.АналитикаРасходов);
	ПараметрыРасхода.Вставить("Комментарий", "Создан автоматически");

	Попытка
		Результат = Документы.мх_РегистрацияРасходов.ДобавитьРасход(ПараметрыРасхода);
	Исключение
		Результат.Успех = Ложь;
		Результат.ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;

	Возврат Результат;

КонецФункции

Функция СоздатьДоход(Знач РеквизитыПлатежа)

	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");

	ПараметрыДохода = РеквизитыПлатежа;
	ПараметрыДохода.Вставить("СтатьяДоходов", РеквизитыПлатежа.СтатьяДоходовРасходов);
	ПараметрыДохода.Вставить("АналитикаДоходов", РеквизитыПлатежа.АналитикаДоходов);
	ПараметрыДохода.Вставить("Комментарий", "Создан автоматически");

	Попытка
		Результат = Документы.мх_РегистрацияДоходов.ДобавитьДоход(ПараметрыДохода);
	Исключение
		Результат.Успех = Ложь;
		Результат.ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;

	Возврат Результат;

КонецФункции
#КонецОбласти