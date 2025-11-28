import sqlite3

def make_connect():
    try:
        conn = sqlite3.connect('db.db')
        return conn
    except:
        print('ошибка')


def clean_dict(func):
    def wrapper(*args, **kwargs):
        initial_dict = func(*args, **kwargs)
        id = initial_dict.pop('id', None)
        match id: 
            case 1:
                items_to_pop = ['f_name', 's_name', 'p_name', 'date_entry', 'format', 'group_num', 'year', 'grade']
                for item in items_to_pop:
                    initial_dict.pop(item, None)
            case 2:
                items_to_pop = ['date_entry', 'year']
                for item in items_to_pop:
                    initial_dict.pop(item, None)
            case 3:
                return initial_dict
        return initial_dict
    return wrapper
    


'''
Предлагаю сделать три роли, гость, студент, препод 

гость сможет просматривать только информацию о курсах
студент - о курсах и своих оценках, ну и свою инфу
препод - может просматривать все, и менять тоже собственно

механизм авторизации и регистрации делать не будем думаю, ибо запарно и нет особо смысла, 
давайте внизу страницы просто сделаем переключатель, которые будет определять роль соответсвующую


я в свою очередь пропишу сейчас функции, которые будут определать разные роли 

'''



def get_students_by_format(format: str) -> int: #функция которая получает кол-во студентов в зависимости от формы обучения
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('SELECT COUNT(student_id) FROM students WHERE format = ?',(format,))
    students = cursor.fetchone()
    if students is not None:
        conn.close()
        return students[0]
    else:
        return 'Такой формы обучения нет'
    
    
def get_students_by_group(format: str) -> int: #функция которая получает кол-во студентов в зависимости от формы обучения
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('SELECT COUNT(student_id) FROM students WHERE group_num = ?', (format,))
    students = cursor.fetchone()
    if students is not None:
        conn.close()
        return students[0]
    else:
        return 'Такой группы обучения нет'

def get_hours_exam_by_spec(subj: str) -> dict: # функция 2 возвращает словарь формата {'hours': 56, 'exam': 'Зачет'}
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('SELECT plan_hours, exam FROM edu_plan WHERE subject = ?',(subj,))
    rows = cursor.fetchone()
    if rows is not None:
        param = {
            'hours' : rows[0],
            'exam' : rows[1]
        }
        conn.close()
        return param
    else:
        return 'Такого предмета нет'



def get_student_id_by_name(f_name: str, s_name: str) -> int: # получения пстудента по фамилии
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('SELECT student_id FROM students WHERE f_name = ? and s_name = ?', (f_name, s_name,))
    student_id = cursor.fetchone()
    conn.close()
    if student_id is None:
        return 'Такого студента нет'
    else:
        return student_id[0]


def get_spec_id_by_subject(subj: str) -> int: # функцияя для получения id спец курса по предмету
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('SELECT spec_id FROM edu_plan WHERE subject = ?', (subj,))
    course_id = cursor.fetchone()
    conn.close()
    if course_id is None:
        return 'Такого курса нет'
    else:
        return course_id[0]

# тут я создам комплект функций для обновления данных об успеваемости и прочем

@clean_dict # декоратор находится выше
def get_all_data(f_name:str, s_name: str,  subject: str, id: int) -> dict: # функция будет возвращать все данные по параметрам, чтобы потом можно было реализовать функцию для изменения данных
    conn = make_connect()
    cursor = conn.cursor()
    
    student_id = get_student_id_by_name(f_name, s_name)
    
    course_id = get_spec_id_by_subject(subject)
    
    params = ['f_name', 's_name', 'p_name', 'date_entry', 'format', 'group_num', 
                    'spec_name', 'subject', 'semester', 'plan_hours', 'exam', 'year', 'grade']
    
    cursor.execute('''SELECT f_name, s_name, p_name, date_entry, format, group_num, 
                    spec_name, subject, edu_plan.semester, plan_hours, exam, year, grade 
                    FROM journal j
                        INNER JOIN students USING (student_id) 
                        INNER JOIN edu_plan USING (spec_id) 
                   WHERE j.student_id = ? AND j.spec_id = ? AND edu_plan.subject = ?''', (student_id, course_id, subject,))
    
    rows = cursor.fetchall()
    if rows is None:
        return ('Такая запись отсутствует')
    else: 
        data = dict(zip(params, list(rows[0])))
        data['id'] = id

        return data

def get_subjects():
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('''SELECT DISTINCT subject FROM edu_plan''')
    formats = []
    rows = cursor.fetchall()
    for row in rows:
        formats.append(row[0])
    return formats

def add_data(data: dict): # добавление данных, доступно только преподам
    conn = make_connect()
    cursor = conn.cursor()
    


    student_id = get_student_id_by_name(data['f_name'], data['s_name'])

    course_id = get_spec_id_by_subject(data['subject'])

    
    cursor.execute('''SELECT j_id FROM journal WHERE student_id = ? AND spec_id = ?''', (student_id, course_id,))

    rows = cursor.fetchone()
    if rows is None:
        cursor.execute('INSERT INTO journal (semester, year, student_id, spec_id, grade) VALUES (?,?,?,?,?)',
                   (data['semester'], data['year'], student_id, course_id, data['grade'],))
        conn.commit()
        conn.close()
        return 'Запись добавлена'
    else:
        conn.close()
        return 'Такая запись уже имеется'



def add_student(data: dict): # добавление студента
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('''SELECT student_id FROM students WHERE f_name = ? AND s_name = ?''', 
                   (data['f_name'], data['s_name']))
    rows = cursor.fetchone()


    if rows is None:
        cursor.execute('INSERT INTO students (f_name, s_name,  date_entry, format, group_num) VALUES (?,?,?,?,?)', 
                   (data['f_name'], data['s_name'],  data['date_entry'], data['format'], data['group_num'],))
        conn.commit()
        conn.close()
        return 'Запись сохранена'
    else:
        conn.close()
        return 'Такая запись уже имеется'
    
#data = {'f_name': 'Олег', 's_name': 'Лобанов', 'p_name': None, 'date_entry': '01-09-2023', 'format': 'Вечерняя', 'group_num': 143, 'spec_name': 'Биг дата', 'subject': 'Мат. стат', 'semester': 2, 'plan_hours': 128, 'exam': 'Экзамен', 'year': '2023', 'grade': 3}

def add_course(data: dict): #Добавление курса
    conn = make_connect()
    cursor = conn.cursor()
    

    cursor.execute('''SELECT spec_id FROM edu_plan  WHERE spec_name = ? and subject = ?''',
                   (data['spec_name'], data['subject'], ))
    
    rows = cursor.fetchone()
    
    if rows is None:
        cursor.execute('INSERT INTO edu_plan (spec_name, subject, semester, plan_hours, exam) VALUES (?,?,?,?,?)', (
            data['spec_name'], data['subject'], data['semester'], data['plan_hours'], data['exam'],))
    
        conn.commit()
        conn.close()
        return 'Запись сохранена'
    else:
        conn.close()
        return 'Такая запись уже имеется'



def alter_journal(s_data: dict):#функция для изменения данных в журнале, сначала получаем все данные из функции выше, меняем их, после чего заменяем
    student_id = get_student_id_by_name(s_data['f_name'], s_data['s_name'])
    course_id = get_spec_id_by_subject(s_data['subject'])
    conn = make_connect()
    cursor = conn.cursor()

    cursor.execute('''UPDATE students SET  
                   format = ? where student_id = ?''',
                   ( s_data['format'], student_id,))
    
    cursor.execute('''UPDATE edu_plan SET plan_hours = ? WHERE spec_id = ?''', (s_data['plan_hours'], course_id,))

    cursor.execute('''UPDATE journal SET grade = ? WHERE student_id = ? AND spec_id = ?''',
                   (s_data['grade'], student_id, course_id,))

    conn.commit()
    conn.close()

def get_specs():
    conn = make_connect()
    cursor = conn.cursor()
    cursor.execute('''SELECT DISTINCT spec_name FROM edu_plan''')
    formats = []
    rows = cursor.fetchall()
    for row in rows:
        formats.append(row[0])
    return formats


if __name__ == '__main__':
    data = {'f_name': 'Андрей', 's_name': 'Зайцев', 'p_name': 'Артемович', 'date_entry': '05-01-2025', 'format': 'Заочная', 'group_num': 125, 'spec_name': 'Дизайн', 'subject': 'ui/ux-дизайн', 'semester': '1', 'plan_hours': 35, 'exam': 'Зачет', 'year': '2025', 'grade': 5}
    #add_course(data)
    print(get_all_data('Антон','Антонов', 'ui/ux-дизайн', 3))# протестите функцию с id от 1-3
    print(get_hours_exam_by_spec('ui/ux-дизайн'))
    print(get_subjects())

