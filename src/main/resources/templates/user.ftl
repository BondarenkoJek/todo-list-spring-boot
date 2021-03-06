<html>
<head>
    <title>TodoList</title>
    <link rel="stylesheet" href="/styles/user.css">

</head>
<body>
<form action="/logout" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

    <input type="submit" value="Sign Out"/>
</form>

    <main id="app">
        <header>
            <h1>Todo for ${userName}</h1>
        </header>
    <ul id="todo-list">
    <#list list as task>
            <li class="todo-item <#if task.state>completed</#if>">
                <input class="checkbox" type="checkbox" value="${task.id}" <#if task.state>checked</#if> >

                <label class="textdate">${task.date}</label>

                <label  class="title">${task.description}</label>
                <input  class="textfield" type="text">

                <button class="edit" value="${task.id}">Edit</button>
                <button class="delete" value="${task.id}">Delete</button>

            </li>
    </#list>
    </ul>
<#if (count > 1) >
        <div class="numberPages">
                <#list 1..count as i>

                    <p class="numberPage" <#if (numberPage == i)>style="color: brown" </#if>>
                        <a <#if !(numberPage == i)> href="/${userName}/page/${i}"</#if> >${i}</a>
                    </p>

                </#list>
        </div>
</#if>

        <div>
            <form id="todo-form" action="/add" method="get">
            <input type="hidden" name="userName" v>
            <input id="add-input"  name="description"  type="text">
            <button id="add-button" type="submit">Add</button>
            </form>
        </div>
    </main>

    <script>
        function bindEvents(todoItem) {
            const checkbox = todoItem.querySelector('.checkbox');
            const editButton = todoItem.querySelector('button.edit');
            const deleteButton = todoItem.querySelector('button.delete');

            checkbox.addEventListener('change', toggleTodoItem);
            editButton.addEventListener('click', editTodoItem);
            deleteButton.addEventListener('click', deleteTodoItem);
        }

        function deleteTodoItem() {
            request.open('Get', '/delete?id=' + this.value);
            request.send();

            const listItem = this.parentNode;
            todoList.removeChild(listItem);
        }

        function toggleTodoItem() {
            const listItem = this.parentNode;
            listItem.classList.toggle('completed');

            request.open('Get', '/state?id=' + this.value);
            request.send();

        }

        function editTodoItem() {
            const listItem = this.parentNode;
            const title = listItem.querySelector('.title');
            const editInput = listItem.querySelector('.textfield');
            const isEditing = listItem.classList.contains('editing');

            if(isEditing) {
                title.innerText = editInput.value;
                this.innerText = 'Edit';
                request.open('Get', '/edit?id=' + this.value + '&description=' + editInput.value);
                request.send();

            }else {
                editInput.value = title.innerText;
                this.innerText = 'Save';
            }
            listItem.classList.toggle('editing');
        }

        const todoItems = document.querySelectorAll('.todo-item');
        const todoList = document.getElementById('todo-list');
        const request = new XMLHttpRequest();

        function main() {
            todoItems.forEach(item => bindEvents(item));
        }

        main();
    </script>
</body>
</html>





