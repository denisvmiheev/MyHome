///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет стандартное поведение подсистемы Пользователи.
//
// Параметры:
//  Настройки - Структура:
//   * ОбщиеНастройкиВхода - Булево - определяет, будут ли в панели администрирования
//          "Настройки прав и пользователей" доступны настройки входа, и доступность
//          настроек ограничения срока действия в формах пользователя и внешнего пользователя.
//          По умолчанию - Истина, а для базовых версий конфигурации - всегда Ложь.
//
//   * РедактированиеРолей - Булево - определяет доступность интерфейса изменения ролей 
//          в карточках пользователя, внешнего пользователя и группы внешних пользователей
//          (в том числе для администратора). По умолчанию - Истина.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет указать роли, назначение которых будет контролироваться особым образом.
// Большинство ролей конфигурации не требуется здесь указывать, т.к. они предназначены для любых пользователей, 
// кроме внешних пользователей.
//
// Параметры:
//  НазначениеРолей - Структура:
//   * ТолькоДляАдминистраторовСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для администраторов сервиса, например:
//       Администрирование, ОбновлениеКонфигурацииБазыДанных, АдминистраторСистемы,
//     а также все роли с правами:
//       Администрирование,
//       Администрирование расширений конфигурации,
//       Обновление конфигурации базы данных.
//     Такие роли, как правило, существуют только в БСП и не встречаются в прикладных решениях.
//
//   * ТолькоДляПользователейСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для неразделенных пользователей (сотрудников технической поддержки сервиса и
//     администраторов сервиса), например:
//       ДобавлениеИзменениеАдресныхСведений, ДобавлениеИзменениеБанков,
//     а также все роли с правами изменения неразделенных данных и следующими правами:
//       Толстый клиент,
//       Внешнее соединение,
//       Automation,
//       Режим все функции,
//       Интерактивное открытие внешних обработок,
//       Интерактивное открытие внешних отчетов.
//     Такие роли в большей части существует в БСП, но могут встречаться и в прикладных решениях.
//
//   * ТолькоДляВнешнихПользователей - Массив - имена ролей, которые предназначены
//     только для внешних пользователей (роли со специально разработанным набором прав), например:
//       ДобавлениеИзменениеОтветовНаВопросыАнкет, БазовыеПраваВнешнихПользователейБСП.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
//   * СовместноДляПользователейИВнешнихПользователей - Массив - имена ролей, которые предназначены
//     для любых пользователей (и внутренних, и внешних, и неразделенных), например:
//       ЧтениеОтветовНаВопросыАнкет, ДобавлениеИзменениеЛичныхВариантовОтчетов.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет поведение формы пользователя и формы внешнего пользователя,
// группы внешних пользователей, когда оно должно отличаться от поведения по умолчанию.
//
// Например, требуется скрывать/показывать или разрешать изменять/блокировать
// некоторые свойства в случаях, которые определены прикладной логикой.
//
// Параметры:
//  ПользовательИлиГруппа - СправочникСсылка.Пользователи
//                        - СправочникСсылка.ВнешниеПользователи
//                        - СправочникСсылка.ГруппыВнешнихПользователей - ссылка на пользователя,
//                          внешнего пользователя или группу внешних пользователей при создании формы.
//
//  ДействияВФорме - Структура:
//         * Роли                   - Строка - "", "Просмотр", "Редактирование".
//                                             Например, когда роли редактируются в другой форме, можно скрыть
//                                             их в этой форме или только блокировать редактирование.
//         * КонтактнаяИнформация   - Строка - "", "Просмотр", "Редактирование".
//                                             Свойство отсутствует для групп внешних пользователей.
//                                             Например, может потребоваться скрыть контактную информацию
//                                             от пользователя при отсутствии прикладных прав на просмотр КИ.
//         * СвойстваПользователяИБ - Строка - "", "Просмотр", "Редактирование".
//                                             Свойство отсутствует для групп внешних пользователей.
//                                             Например, может потребоваться показать свойства пользователя ИБ
//                                             для пользователя, который имеет прикладные права на эти сведения.
//         * СвойстваЭлемента       - Строка - "", "Просмотр", "Редактирование".
//                                             Например, Наименование является полным именем пользователя ИБ,
//                                             может потребоваться разрешить редактировать наименование
//                                             для пользователя, который имеет прикладные права на кадровые операции.
//
Процедура ИзменитьДействияВФорме(Знач ПользовательИлиГруппа, Знач ДействияВФорме) Экспорт
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
// Например, если требуется синхронно обновить запись в соответствующем регистре и т.п.
// Вызывается из процедуры Пользователи.УстановитьСвойстваПользователяИБ, если пользователь был действительно изменен.
// Если поле Имя в структуре СтарыеСвойства не заполнено, то создается новый пользователь ИБ.
//
// Параметры:
//  СтарыеСвойства - см. Пользователи.НовоеОписаниеПользователяИБ.
//  НовыеСвойства  - см. Пользователи.НовоеОписаниеПользователяИБ.
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
// Например, если требуется синхронно обновить запись в соответствующем регистре и т.п.
// Вызывается из процедуры УдалитьПользователяИБ, если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - см. Пользователи.НовоеОписаниеПользователяИБ.
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
КонецПроцедуры

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей.
// Например, можно установить начальные настройки расположения разделов командного интерфейса.
//
// Параметры:
//  НачальныеНастройки - Структура:
//   * НастройкиКлиента    - НастройкиКлиентскогоПриложения           - настройки клиентского приложения.
//   * НастройкиИнтерфейса - НастройкиКомандногоИнтерфейса            - настройки командного интерфейса (панели
//                                                                      разделов, панели навигации, панели действий).
//   * НастройкиТакси      - НастройкиИнтерфейсаКлиентскогоПриложения - настройки интерфейса клиентского приложения
//                                                                      (состав и размещение панелей).
//
//   * ЭтоВнешнийПользователь - Булево - если Истина, то это внешний пользователь.
//
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет добавить произвольную настройку на закладке "Прочее" в интерфейсе
// обработки НастройкиПользователей, чтобы ее можно было удалять и копировать другим пользователям.
// Для возможности управления настройкой нужно написать код ее по копированию (см. ПриСохраненииПрочихНастроек)
// и удалению (см. ПриУдаленииПрочихНастроек), который будет вызываться при интерактивных действиях с настройкой.
//
// Например, признак того, нужно ли показывать предупреждение при завершении работы программы.
//
// Параметры:
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя:
//       * ПользовательСсылка  - СправочникСсылка.Пользователи - пользователь,
//                               у которого нужно получить настройки.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             у которого нужно получить настройки.
//  Настройки - Структура - прочие пользовательские настройки:
//       * Ключ     - Строка - строковый идентификатор настройки, используемый в дальнейшем
//                             для копирования и очистки этой настройки.
//       * Значение - Структура:
//              ** НазваниеНастройки  - Строка - название, которое будет отображаться в дереве настроек.
//              ** КартинкаНастройки  - Картинка - картинка, которая будет отображаться в дереве настроек.
//              ** СписокНастроек     - СписокЗначений - список полученных настроек.
//
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Сохраняет произвольную настройку переданному пользователю.
// См. также ПриПолученииПрочихНастроек.
//
// Параметры:
//  Настройки - Структура:
//       * ИдентификаторНастройки - Строка - строковый идентификатор копируемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений копируемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя:
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно скопировать настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно скопировать настройку.
//
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Очищает произвольную настройку у переданного пользователя.
// См. также ПриПолученииПрочихНастроек.
//
// Параметры:
//  Настройки - Структура:
//       * ИдентификаторНастройки - Строка - строковый идентификатор очищаемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений очищаемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя:
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно очистить настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно очистить настройку.
//
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет указать свою форму выбора пользователей.
//
// В разрабатываемой форме необходимо:
// - устанавливать отбор Служебный = Ложь, отбор должен сниматься только под полными правами;
// - устанавливать отбор Недействителен = Ложь, отбор должен сниматься под любым пользователем.
//
// При реализации собственной формы необходимо поддержать параметры формы или использовать стандартную форму:
// - ЗакрыватьПриВыборе
// - МножественныйВыбор
// - ВыборУчастниковОбсуждения
//
// Для работы в качестве формы подбора участников обсуждения необходимо:
// - передавать результат выбора в оповещение о закрытии
// - результат выбора должен быть представлен массивом идентификаторов пользователей
//   системы взаимодействия.
//
// Параметры:
//   ВыбраннаяФорма - Строка - имя открываемой формы.
//   ПараметрыФормы - Структура - параметры формы при открытии, только Чтение:
//   * ЗакрыватьПриВыборе - Булево - содержит признак того, что форму
// 									необходимо закрывать после осуществления выбора.
// 									Если свойство имеет значение Ложь, можно использовать
// 									форму для выбора нескольких позиций или элементов.
//   * МножественныйВыбор - Булево - разрешает или запрещает выбор нескольких строк из списка.
//   * ВыборУчастниковОбсуждения - Булево - если Истина, то формы вызывается как форма выбора участников обсуждения.
// 										   Форма должна возвращать массив идентификаторов пользователей системы
// 										   Взаимодействия.
//
//   * ЗаголовокКнопкиЗавершенияПодбора - Строка - заголовок кнопки завершения подбора.
//   * СкрытьПользователейБезПользователяИБ - Булево - если Истина, то пользователи без идентификатора
// 													  пользователя ИБ не должны отображаться в списке.
//   * ВыборГруппПользователей - Булево - разрешить выбирать группы пользователей.
// 										 Если группы пользователей используются и параметр не поддерживается,
// 										 то для группы пользователей нельзя назначать права через форму подбора.
//   * РасширенныйПодбор - Булево - если Истина, то доступен просмотр Групп пользователей.
//   * ПараметрыРасширеннойФормыПодбора - Строка - адрес временного хранилища со структурой:
//   ** СкрываемыеПользователи - Массив - пользователи, которые не отображаются в форме подбора.
//   ** ВыборГруппВнешнихПользователей - Булево - разрешить выбирать группы внешних пользователей.
//   ** ПодборГруппНевозможен - Булево
//   ** ЗаголовокФормыПодбора - Строка - позволяет переопределять заголовок формы подбора.
//   ** ВыбранныеПользователи - Массив - пользователи, которые должны отображаться в подобранных.
//   ** ТекущаяСтрока - СправочникСсылка.ГруппыПользователей - строка, на которой будет выполнена позиционирование 
// 															в динамическом списке групп пользователей
// 															при открытии формы.
//
Процедура ПриОпределенииФормыВыбораПользователей(ВыбраннаяФорма, ПараметрыФормы) Экспорт

	

КонецПроцедуры

#КонецОбласти
