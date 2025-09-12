from flask import Flask, render_template, request, jsonify, session  
from main import *
app = Flask(__name__)
app.secret_key = '225'


# Формы обучения и предметы
forms_study = ["Дневная", "Заочная", "Вечерняя"]
subjects = get_subjects()
exams = ['Зачет', 'Экзамен']
specs = get_specs()

@app.route('/')
def index():
    return render_template('index.html', forms_study=forms_study, subjects=subjects, exams=exams, specs=specs)

@app.route('/get_student_count', methods=['POST'])
def get_student_count():
    form_study = request.form.get('form_study')
    count = get_students_by_format(form_study)
    return jsonify({"count": count})




@app.route('/get_subject_info', methods=['POST'])
def get_subject_info():
    subject = request.form.get('subject')
    subject_info = get_hours_exam_by_spec(subject)
        
    if subject_info:
        return jsonify(subject_info)
    else:
        return jsonify({"error": "Предмет не найден"}), 404
    

@app.route('/get_subject_info', methods=['POST'])
def process_switch():
    data = request.get_json()
    selected_value = data.get('selected_switch') 
    session['val'] = selected_value
    
    if not selected_value:
        return jsonify({'error': 'Не выбрана опция!'})
    
    

@app.route('/get_student_info', methods=['POST'])
def get_student_info():
    last_name = request.form.get('last_name')
    first_name = request.form.get('first_name')
    subject = request.form.get('subject')
    info = get_all_data(f_name=first_name, s_name=last_name, subject=subject, id=3)
    if info:
        return jsonify(info)
    else:
        return jsonify({"error": "Студент не найден"}), 404
    

'''
@app.route('/update_student_info', methods=['POST'])
def update_student_info():
    last_name = request.form.get('last_name')
    first_name = request.form.get('first_name')
    subject = request.form.get('subject')
    new_form_study = request.form.get('new_form_study')
    new_hours = request.form.get('new_hours')
    new_exam_form = request.form.get('new_exam_form')

    for s in students_db:
        if s['last_name'] == last_name and s['first_name'] == first_name and s['subject'] == subject:
            if new_form_study:
                s['form_study'] = new_form_study
            if new_hours:
                try:
                    s['hours'] = int(new_hours)
                except ValueError:
                    pass
            if new_exam_form:
                s['exam_form'] = new_exam_form
            return jsonify({"message": "Данные обновлены", "student": s})
    return jsonify({"error": "Студент не найден"}), 404
'''

@app.route('/add_student', methods=['POST'])
def add_student_n():
    data = request.get_json()
    if not data:
        return jsonify({'success': False, 'error': 'Нет данных'}), 400
    
    try:
        # Предполагаем, что add_student и add_data могут бросать исключения при ошибках
        add_student(data)
        add_data(data)
        # Возвращаем успешный ответ с сообщением
        return jsonify({'success': True, 'message': 'Студент добавлен успешно'})
    except Exception as e:
        # В случае ошибки возвращаем сообщение об ошибке
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/add_subject', methods=['POST'])
def add_course_n():
    data = request.get_json()
    if not data:
        return jsonify({'success': False, 'error': 'Нет данных'}), 400
    
    try:
        # Предполагаем, что add_student и add_data могут бросать исключения при ошибках
        add_course(data)
        
        return jsonify({'success': True, 'message': 'Студент добавлен успешно'})
    except Exception as e:
        # В случае ошибки возвращаем сообщение об ошибке
        return jsonify({'success': False, 'error': add_course(data)}), 500
    


if __name__ == '__main__':
    app.run(debug=True)
