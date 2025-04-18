const { GraphQLObjectType, GraphQLSchema, GraphQLString, GraphQLList, GraphQLBoolean } = require('graphql');
const { Faculty, Teacher, Pulpit, Subject } = require('./models');

// Типы данных
const FacultyType = new GraphQLObjectType({
    name: 'Faculty',
    fields: {
        faculty: { type: GraphQLString },
        name: { type: GraphQLString },
    },
});

const TeacherType = new GraphQLObjectType({
    name: 'Teacher',
    fields: {
        teacher: { type: GraphQLString },
        name: { type: GraphQLString },
        pulpit: { type: GraphQLString },
    },
});

const SubjectType = new GraphQLObjectType({
    name: 'Subject',
    fields: {
        subject: { type: GraphQLString },
        name: { type: GraphQLString },
        pulpit: { type: GraphQLString },
    },
});

const PulpitType = new GraphQLObjectType({
    name: 'Pulpit',
    fields: {
        pulpit: { type: GraphQLString },
        name: { type: GraphQLString },
        faculty: { type: GraphQLString },
        subjects: { type: new GraphQLList(SubjectType) },
    },
});

// Запросы
const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        getFaculties: {
            type: new GraphQLList(FacultyType),
            args: { faculty: { type: GraphQLString } },
            resolve(parent, args) {
                console.log("Запрос на факультеты", args);
                return args.faculty
                    ? Faculty.findAll({ where: { faculty: args.faculty } })
                    : Faculty.findAll();
            },
        },
        getTeachers: {
            type: new GraphQLList(TeacherType),
            args: { teacher: { type: GraphQLString } },
            resolve(parent, args) {
                return args.teacher
                    ? Teacher.findAll({ where: { teacher: args.teacher } })
                    : Teacher.findAll();
            },
        },
        getPulpits: {
            type: new GraphQLList(PulpitType),
            args: { pulpit: { type: GraphQLString } },
            resolve: async (parent, args) => {
                const pulpits = await Pulpit.findAll({
                    where: args.pulpit ? { pulpit: args.pulpit } : {},
                    include: [{ model: Subject }]
                });
        
                return pulpits.map(pulpit => ({
                    ...pulpit.toJSON(), 
                    subjects: pulpit.Subjects || []
                }));},
        },
        getSubjects: {
            type: new GraphQLList(SubjectType),
            args: {
                subject: { type: GraphQLString },
                pulpit: { type: GraphQLString }
            },
            resolve(parent, args) {
                const queryOptions = {};
                if (args.subject) {
                    queryOptions.subject = args.subject;
                }
                if (args.pulpit) {
                    queryOptions.pulpit = args.pulpit;
                }
                return Subject.findAll({ where: queryOptions });
            },
        },
        getTeachersByFaculty: {
            type: new GraphQLList(TeacherType),
            args: { faculty: { type: GraphQLString } },
            resolve(parent, args) {
                return Teacher.findAll({
                    include: [{
                        model: Pulpit,
                        where: { faculty: args.faculty },
                    }]
                });
            },
        },
        getSubjectsByFaculties: {
            type: new GraphQLList(PulpitType),
            args: { faculty: { type: GraphQLString } },
            resolve: async (parent, args) => {
                const pulpits = await Pulpit.findAll({
                    where: { faculty: args.faculty },
                    include: [{ model: Subject }]
                });
        
                return pulpits.map(pulpit => ({
                    ...pulpit.toJSON(), 
                    subjects: pulpit.Subjects || [] 
                }));
            },
        },
    },
});

// Мутации
const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        setFaculty: {
            type: FacultyType,
            args: {
                faculty: { type: GraphQLString },
                name: { type: GraphQLString },
            },
            resolve: async (parent, args) => {
                const [faculty] = await Faculty.upsert({ faculty: args.faculty, name: args.name });
                return faculty;
            }
        },
        setTeacher: {
            type: TeacherType,
            args: {
                teacher: { type: GraphQLString },
                name: { type: GraphQLString },
                pulpit: { type: GraphQLString },
            },
            resolve: async (parent, args) => {
                const [teacher] = await Teacher.upsert({ teacher: args.teacher, name: args.name, pulpit: args.pulpit });
                return teacher;
            },
        },
        setPulpit: {
            type: PulpitType,
            args: {
                pulpit: { type: GraphQLString },
                name: { type: GraphQLString },
                faculty: { type: GraphQLString },
            },
            resolve: async (parent, args) => {
                const [pulpit] = await Pulpit.upsert({ pulpit: args.pulpit, name: args.name, faculty: args.faculty });
                return pulpit;
            },
        },
        setSubject: {
            type: SubjectType,
            args: {
                subject: { type: GraphQLString },
                name: { type: GraphQLString },
                pulpit: { type: GraphQLString },
            },
            resolve: async (parent, args) => {
                const [subject] = await Subject.upsert({ subject: args.subject, name: args.name, pulpit: args.pulpit });
                return subject;
            },
        },
        delFaculty: {
            type: GraphQLBoolean, 
            args: { faculty: { type: GraphQLString } },
            resolve: async (parent, args) => {
                const faculty = await Faculty.findOne({ where: { faculty: args.faculty } });
                if (!faculty) return false; 
                await Faculty.destroy({ where: { faculty: args.faculty } });
                return true; 
            },
        },
        
        delTeacher: {
            type: GraphQLBoolean,  
            args: { teacher: { type: GraphQLString } },
            resolve: async (parent, args) => {
                const teacher = await Teacher.findOne({ where: { teacher: args.teacher } });
                if (!teacher) return false;  
                await Teacher.destroy({ where: { teacher: args.teacher } });
                return true;  
            },
        },
        delPulpit: {
            type: GraphQLBoolean,  
            args: { pulpit: { type: GraphQLString } },
            resolve: async (parent, args) => {
                const pulpit = await Pulpit.findOne({ where: { pulpit: args.pulpit } });
                if (!pulpit) return false; 
                await Pulpit.destroy({ where: { pulpit: args.pulpit } });
                return true;  
            },
        },
        delSubject: {
            type: GraphQLBoolean, 
            args: { subject: { type: GraphQLString } },
            resolve: async (parent, args) => {
                const subject = await Subject.findOne({ where: { subject: args.subject } });
                if (!subject) return false;  
                await Subject.destroy({ where: { subject: args.subject } });
                return true;  
            },
        },
        
        
    },
});

module.exports = new GraphQLSchema({
    query: RootQuery,
    mutation: Mutation,
});
