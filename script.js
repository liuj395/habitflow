// 应用状态管理
class HabitApp {
    constructor() {
        this.habits = JSON.parse(localStorage.getItem('habits')) || [];
        this.achievements = JSON.parse(localStorage.getItem('achievements')) || this.initAchievements();
        this.currentFilter = 'all';
        this.init();
    }

    init() {
        this.bindEvents();
        this.renderHabits();
        this.updateStats();
        this.renderAchievements();
        this.checkAchievements();
    }

    // 初始化成就系统
    initAchievements() {
        return [
            {
                id: 'first_habit',
                name: '初学者',
                description: '添加第一个习惯',
                icon: 'fas fa-seedling',
                unlocked: false,
                condition: () => this.habits.length >= 1
            },
            {
                id: 'week_streak',
                name: '坚持一周',
                description: '连续完成7天',
                icon: 'fas fa-calendar-week',
                unlocked: false,
                condition: () => this.habits.some(h => h.streak >= 7)
            },
            {
                id: 'month_streak',
                name: '月度达人',
                description: '连续完成30天',
                icon: 'fas fa-calendar-alt',
                unlocked: false,
                condition: () => this.habits.some(h => h.streak >= 30)
            },
            {
                id: 'five_habits',
                name: '多面手',
                description: '同时管理5个习惯',
                icon: 'fas fa-star',
                unlocked: false,
                condition: () => this.habits.length >= 5
            },
            {
                id: 'perfect_week',
                name: '完美一周',
                description: '一周内完成所有习惯',
                icon: 'fas fa-trophy',
                unlocked: false,
                condition: () => this.checkPerfectWeek()
            },
            {
                id: 'hundred_points',
                name: '百分达人',
                description: '获得100积分',
                icon: 'fas fa-gem',
                unlocked: false,
                condition: () => this.getTotalPoints() >= 100
            }
        ];
    }

    // 绑定事件
    bindEvents() {
        // 添加习惯
        document.getElementById('addHabitBtn').addEventListener('click', () => {
            this.addHabit();
        });

        document.getElementById('habitInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.addHabit();
            }
        });

        // 筛选标签
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.setFilter(e.target.dataset.filter);
            });
        });

        // 模态框
        document.getElementById('closeModal').addEventListener('click', () => {
            this.closeModal();
        });

        document.getElementById('habitModal').addEventListener('click', (e) => {
            if (e.target.id === 'habitModal') {
                this.closeModal();
            }
        });

        // 底部导航
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchPage(e.currentTarget.dataset.page);
            });
        });
    }

    // 添加习惯
    addHabit() {
        const input = document.getElementById('habitInput');
        const typeSelect = document.getElementById('habitType');
        const name = input.value.trim();
        const type = typeSelect.value;

        if (!name) {
            alert('请输入习惯名称');
            return;
        }

        const habit = {
            id: Date.now(),
            name: name,
            type: type,
            streak: 0,
            totalCompleted: 0,
            lastCompleted: null,
            createdAt: new Date().toISOString(),
            completedDates: []
        };

        this.habits.push(habit);
        this.saveData();
        this.renderHabits();
        this.updateStats();
        this.checkAchievements();

        input.value = '';
        input.focus();
    }

    // 切换习惯完成状态
    toggleHabit(habitId) {
        const habit = this.habits.find(h => h.id === habitId);
        if (!habit) return;

        const today = new Date().toDateString();
        const isCompletedToday = habit.completedDates.includes(today);

        if (isCompletedToday) {
            // 取消完成
            habit.completedDates = habit.completedDates.filter(date => date !== today);
            habit.totalCompleted = Math.max(0, habit.totalCompleted - 1);
            this.updateStreak(habit);
        } else {
            // 标记完成
            habit.completedDates.push(today);
            habit.totalCompleted++;
            habit.lastCompleted = today;
            this.updateStreak(habit);
        }

        this.saveData();
        this.renderHabits();
        this.updateStats();
        this.checkAchievements();
    }

    // 更新连续天数
    updateStreak(habit) {
        const sortedDates = habit.completedDates
            .map(date => new Date(date))
            .sort((a, b) => b - a);

        if (sortedDates.length === 0) {
            habit.streak = 0;
            return;
        }

        let streak = 1;
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        // 检查是否今天完成了
        const latestDate = sortedDates[0];
        latestDate.setHours(0, 0, 0, 0);

        if (latestDate.getTime() !== today.getTime()) {
            // 如果最新完成日期不是今天，检查是否是昨天
            const yesterday = new Date(today);
            yesterday.setDate(yesterday.getDate() - 1);

            if (latestDate.getTime() !== yesterday.getTime()) {
                habit.streak = 0;
                return;
            }
        }

        // 计算连续天数
        for (let i = 1; i < sortedDates.length; i++) {
            const currentDate = sortedDates[i];
            const previousDate = sortedDates[i - 1];
            currentDate.setHours(0, 0, 0, 0);
            previousDate.setHours(0, 0, 0, 0);

            const diffTime = previousDate.getTime() - currentDate.getTime();
            const diffDays = diffTime / (1000 * 60 * 60 * 24);

            if (diffDays === 1) {
                streak++;
            } else {
                break;
            }
        }

        habit.streak = streak;
    }

    // 删除习惯
    deleteHabit(habitId) {
        if (confirm('确定要删除这个习惯吗？')) {
            this.habits = this.habits.filter(h => h.id !== habitId);
            this.saveData();
            this.renderHabits();
            this.updateStats();
            this.closeModal();
        }
    }

    // 设置筛选器
    setFilter(filter) {
        this.currentFilter = filter;
        
        // 更新标签状态
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.filter === filter);
        });

        this.renderHabits();
    }

    // 渲染习惯列表
    renderHabits() {
        const container = document.getElementById('habitsList');
        const emptyState = document.getElementById('emptyState');
        
        let filteredHabits = this.habits;
        if (this.currentFilter !== 'all') {
            filteredHabits = this.habits.filter(h => h.type === this.currentFilter);
        }

        if (filteredHabits.length === 0) {
            container.innerHTML = '';
            emptyState.style.display = 'block';
            return;
        }

        emptyState.style.display = 'none';
        
        container.innerHTML = filteredHabits.map(habit => {
            const today = new Date().toDateString();
            const isCompletedToday = habit.completedDates.includes(today);
            
            return `
                <div class="habit-item ${habit.type}-type" data-habit-id="${habit.id}">
                    <div class="habit-header">
                        <span class="habit-name">${habit.name}</span>
                        <span class="habit-type ${habit.type}">
                            ${habit.type === 'build' ? '培养' : '戒除'}
                        </span>
                    </div>
                    <div class="habit-progress">
                        <div class="habit-stats">
                            <span><i class="fas fa-fire"></i> ${habit.streak}天</span>
                            <span><i class="fas fa-check"></i> ${habit.totalCompleted}次</span>
                        </div>
                        <button class="check-btn ${habit.type}-type ${isCompletedToday ? 'completed' : ''}" 
                                onclick="app.toggleHabit(${habit.id})">
                            <i class="fas ${isCompletedToday ? 'fa-check' : 'fa-plus'}"></i>
                        </button>
                    </div>
                </div>
            `;
        }).join('');

        // 添加点击事件显示详情
        container.querySelectorAll('.habit-item').forEach(item => {
            item.addEventListener('click', (e) => {
                if (!e.target.closest('.check-btn')) {
                    const habitId = parseInt(item.dataset.habitId);
                    this.showHabitDetails(habitId);
                }
            });
        });
    }

    // 显示习惯详情
    showHabitDetails(habitId) {
        const habit = this.habits.find(h => h.id === habitId);
        if (!habit) return;

        document.getElementById('modalTitle').textContent = habit.name;
        document.getElementById('modalStreak').textContent = habit.streak;
        document.getElementById('modalTotal').textContent = habit.totalCompleted;

        // 绑定删除按钮
        document.getElementById('deleteHabitBtn').onclick = () => {
            this.deleteHabit(habitId);
        };

        // 显示模态框
        document.getElementById('habitModal').classList.add('show');

        // 绘制进度图表
        this.drawProgressChart(habit);
    }

    // 绘制进度图表
    drawProgressChart(habit) {
        const canvas = document.getElementById('progressChart');
        const ctx = canvas.getContext('2d');
        
        // 清空画布
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // 获取最近7天的数据
        const last7Days = [];
        const today = new Date();
        
        for (let i = 6; i >= 0; i--) {
            const date = new Date(today);
            date.setDate(date.getDate() - i);
            const dateString = date.toDateString();
            const completed = habit.completedDates.includes(dateString);
            last7Days.push({
                date: date.getDate(),
                completed: completed
            });
        }

        // 绘制图表
        const barWidth = 30;
        const barSpacing = 10;
        const maxHeight = 100;
        const startX = 20;
        const startY = canvas.height - 30;

        last7Days.forEach((day, index) => {
            const x = startX + index * (barWidth + barSpacing);
            const height = day.completed ? maxHeight : 20;
            const y = startY - height;

            // 绘制柱状图
            ctx.fillStyle = day.completed ? '#4CAF50' : '#e0e0e0';
            ctx.fillRect(x, y, barWidth, height);

            // 绘制日期标签
            ctx.fillStyle = '#666';
            ctx.font = '12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(day.date, x + barWidth / 2, startY + 20);
        });
    }

    // 关闭模态框
    closeModal() {
        document.getElementById('habitModal').classList.remove('show');
    }

    // 更新统计数据
    updateStats() {
        const today = new Date().toDateString();
        const completedToday = this.habits.filter(h => 
            h.completedDates.includes(today)
        ).length;

        const totalHabits = this.habits.length;
        const completionRate = totalHabits > 0 ? 
            Math.round((completedToday / totalHabits) * 100) : 0;
        const totalPoints = this.getTotalPoints();
        const totalStreak = this.habits.reduce((sum, h) => sum + h.streak, 0);

        document.getElementById('completedToday').textContent = completedToday;
        document.getElementById('totalHabits').textContent = totalHabits;
        document.getElementById('completionRate').textContent = completionRate + '%';
        document.getElementById('totalPoints').textContent = totalPoints;
        document.getElementById('totalStreak').textContent = totalStreak;
    }

    // 计算总积分
    getTotalPoints() {
        return this.habits.reduce((total, habit) => {
            return total + (habit.totalCompleted * 10) + (habit.streak * 5);
        }, 0);
    }

    // 检查完美一周
    checkPerfectWeek() {
        if (this.habits.length === 0) return false;

        const today = new Date();
        let perfectDays = 0;

        for (let i = 0; i < 7; i++) {
            const date = new Date(today);
            date.setDate(date.getDate() - i);
            const dateString = date.toDateString();

            const completedHabits = this.habits.filter(h => 
                h.completedDates.includes(dateString)
            ).length;

            if (completedHabits === this.habits.length) {
                perfectDays++;
            }
        }

        return perfectDays >= 7;
    }

    // 渲染成就
    renderAchievements() {
        const container = document.getElementById('achievementsList');
        
        container.innerHTML = this.achievements.map(achievement => `
            <div class="achievement-item ${achievement.unlocked ? 'unlocked' : ''}">
                <div class="achievement-icon">
                    <i class="${achievement.icon}"></i>
                </div>
                <div class="achievement-name">${achievement.name}</div>
                <div class="achievement-desc">${achievement.description}</div>
            </div>
        `).join('');
    }

    // 检查成就
    checkAchievements() {
        let newAchievements = false;

        this.achievements.forEach(achievement => {
            if (!achievement.unlocked && achievement.condition()) {
                achievement.unlocked = true;
                newAchievements = true;
                this.showAchievementNotification(achievement);
            }
        });

        if (newAchievements) {
            this.saveData();
            this.renderAchievements();
        }
    }

    // 显示成就通知
    showAchievementNotification(achievement) {
        // 创建通知元素
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #FFD700, #FFA500);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            z-index: 1001;
            animation: slideIn 0.3s ease-out;
            max-width: 250px;
        `;

        notification.innerHTML = `
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="${achievement.icon}" style="font-size: 24px;"></i>
                <div>
                    <div style="font-weight: 600; margin-bottom: 5px;">🎉 成就解锁！</div>
                    <div style="font-size: 14px;">${achievement.name}</div>
                </div>
            </div>
        `;

        document.body.appendChild(notification);

        // 3秒后自动移除
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 3000);
    }

    // 切换页面
    switchPage(page) {
        // 更新导航状态
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.page === page);
        });

        // 显示/隐藏对应部分
        const sections = {
            habits: ['.habits-section', '.quick-add'],
            stats: ['.stats-section'],
            achievements: ['.achievements-section'],
            settings: [] // 设置页面暂未实现
        };

        // 隐藏所有部分
        document.querySelectorAll('.habits-section, .quick-add, .stats-section, .achievements-section').forEach(el => {
            el.style.display = 'none';
        });

        // 显示对应部分
        if (sections[page]) {
            sections[page].forEach(selector => {
                const element = document.querySelector(selector);
                if (element) {
                    element.style.display = 'block';
                }
            });
        }
    }

    // 保存数据
    saveData() {
        localStorage.setItem('habits', JSON.stringify(this.habits));
        localStorage.setItem('achievements', JSON.stringify(this.achievements));
    }
}

// 初始化应用
const app = new HabitApp();

// 添加CSS动画
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOut {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100%);
        }
    }
`;
document.head.appendChild(style);